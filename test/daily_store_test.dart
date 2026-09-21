import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:wordly/src/feature/game/data/daily_store.dart';
import 'package:wordly/src/feature/game/data/game_result_board_codec.dart';
import 'package:wordly/src/feature/game/model/game_result.dart';
import 'package:wordly/src/feature/game/model/letter_info.dart';
import 'package:wordly/src/feature/level/data/database/app_database.dart';
import 'package:wordly/src/feature/statistic/data/statistic_codec.dart';
import 'package:wordly/src/feature/statistic/model/game_statistic.dart';

void main() {
  late AppDatabase database;
  late SharedPreferencesAsync preferences;
  late DailyStore store;
  setUp(() {
    final SharedPreferencesAsyncPlatform? previous = SharedPreferencesAsyncPlatform.instance;
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
    addTearDown(() => SharedPreferencesAsyncPlatform.instance = previous);
    database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    preferences = SharedPreferencesAsync();
    store = DailyStore(database: database, preferences: preferences);
  });

  final win = GameResult(
    secretWord: 'apple',
    isWin: true,
    board: [for (final letter in 'apple'.split('')) LetterInfo(letter: letter, status: LetterStatus.correctSpot)],
  );

  test('imports only legacy statistics once, leaves legacy daily and levels untouched', () async {
    const legacy = GameStatistic(wins: 7, loses: 2, streak: 3, maxStreak: 5, attempts: [7, 0, 0, 0, 0, 0]);
    await preferences.setString('statistic.en', jsonEncode(const StatisticCodec().encode(legacy)));
    await preferences.setString(
      'game.board.en.0',
      jsonEncode({...const GameResultBoardCodec().encode(win), 'date': '01-09-2026'}),
    );
    await database.customStatement(
      "INSERT INTO level_results(dictionary_code, level_number, secret_word, is_win) VALUES ('en', 1, 'apple', 1)",
    );
    await store.importLegacyStatistics();
    expect(await store.readStatistic('en'), legacy);
    expect(await store.getDaily('en', '01-09-2026'), isNull);
    await store.saveDaily('en', '02-09-2026', win);
    await store.importLegacyStatistics();
    expect((await store.readStatistic('en')).wins, 8);
    expect(await database.select(database.levelResults).get(), hasLength(1));
  });

  test('rolls back statistics when board write fails, retry commits both exactly once', () async {
    await store.importLegacyStatistics();
    await database.customStatement(
      'CREATE TRIGGER fail_daily BEFORE INSERT ON daily_games '
      "BEGIN SELECT RAISE(ABORT, 'injected disk error'); END",
    );
    await expectLater(store.saveDaily('en', '01-09-2026', win), throwsA(anything));
    expect((await store.readStatistic('en')).wins, 0);
    expect(await store.getDaily('en', '01-09-2026'), isNull);
    await database.customStatement('DROP TRIGGER fail_daily');
    await store.saveDaily('en', '01-09-2026', win);
    // A new store simulates retry after the original completion acknowledgement was lost.
    final reopened = DailyStore(database: database, preferences: preferences);
    await reopened.saveDaily('en', '01-09-2026', win);
    expect((await reopened.readStatistic('en')).wins, 1);
    expect((await reopened.readStatistic('en')).attempts, [1, 0, 0, 0, 0, 0]);
    final GameResult? saved = await reopened.getDaily('en', '01-09-2026');
    expect(saved!.dailyDate, DateTime.utc(2026, 9));
    expect(saved.isWin, isTrue);
  });

  test('progress, losses, languages and previous day retries remain separate', () async {
    await store.importLegacyStatistics();
    await store.saveDaily('en', '01-09-2026', const GameResult(secretWord: 'apple'));
    expect((await store.readStatistic('en')).wins, 0);
    final loss = GameResult(
      secretWord: 'apple',
      isWin: false,
      board: [for (var i = 0; i < 30; i++) const LetterInfo(letter: 'x', status: LetterStatus.notInWord)],
    );
    await store.saveDaily('en', '01-09-2026', loss);
    await store.saveDaily('en', '02-09-2026', win);
    await store.saveDaily('en', '01-09-2026', loss);
    expect((await store.readStatistic('en')).loses, 1);
    expect((await store.readStatistic('en')).wins, 1);
    expect((await store.readStatistic('ru')).wins, 0);
    expect((await store.getDaily('en', '02-09-2026'))!.isWin, isTrue);
    expect((await store.getDaily('en', '01-09-2026'))!.isWin, isFalse);
  });
}
