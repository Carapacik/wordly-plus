import 'dart:io';
import 'dart:ui';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wordly/src/feature/game/data/dictionary/dictionary_database.dart';
import 'package:wordly/src/feature/game/data/game_datasource.dart';
import 'package:wordly/src/feature/game/data/game_repository.dart';
import 'package:wordly/src/feature/game/model/game_result.dart';

void main() {
  test('repository uses full levels, curated daily and stable positions after dictionary edits', () async {
    final Directory temporary = Directory.systemTemp.createTempSync('wordly-schedule-');
    addTearDown(() => temporary.deleteSync(recursive: true));
    final File ruFile = File('assets/dictionary/ru.sqlite').copySync('${temporary.path}/ru.sqlite');
    final File enFile = File('assets/dictionary/en.sqlite').copySync('${temporary.path}/en.sqlite');
    final ru = DictionaryDatabase(NativeDatabase(ruFile));
    final en = DictionaryDatabase(NativeDatabase(enFile));
    final List<String> before = await en.scheduledWords(daily: false);
    final List<String> dailyBefore = await en.scheduledWords(daily: true);
    // Simulate a later asset release: changed definitions and an extra guess,
    // while keeping the published positions unchanged.
    await en.customStatement('PRAGMA query_only = OFF');
    await en.customStatement("UPDATE words SET definition = 'Updated source definition' WHERE word = 'apple'");
    await en.customStatement("INSERT INTO words(word, definition) VALUES ('zzzzz', 'Synthetic test-only guess')");
    await en.customStatement('PRAGMA query_only = ON');
    DateTime now = DateTime.parse('2026-09-01T23:59:59Z');
    final datasource = _Datasource();
    final repository = GameRepository(gameDataSource: datasource, ruDatabase: ru, enDatabase: en, clock: () => now);
    addTearDown(repository.close);
    await repository.init(const Locale('en'));
    expect(repository.generateSecretWord(const Locale('en')), 'stage');
    expect(repository.generateSecretWord(const Locale('ru')), 'лопух');
    expect(repository.containsWord(const Locale('en'), 'jaups'), isTrue);
    expect(repository.containsWord(const Locale('en'), 'zzzzz'), isTrue);
    expect(await repository.definition(const Locale('en'), 'apple'), 'Updated source definition');
    expect([
      for (var i = 1; i <= before.length; i++) repository.generateSecretWord(const Locale('en'), levelNumber: i),
    ], orderedEquals(before));
    expect(await en.scheduledWords(daily: true), orderedEquals(dailyBefore));
    expect(repository.generateSecretWord(const Locale('en'), levelNumber: 1), 'jaups');
    expect(repository.generateSecretWord(const Locale('ru'), levelNumber: 1), 'жирши');
    now = DateTime.parse('2026-09-02T03:00:00+03:00');
    expect(repository.generateSecretWord(const Locale('en')), 'arena');
    expect(repository.generateSecretWord(const Locale('ru')), 'наука');
    await repository.getDaily(const Locale('en'), DateTime.parse('2026-09-02T01:00:00+03:00'));
    expect(datasource.lastDate, '01-09-2026');
  });
}

final class _Datasource() implements IGameDatasource {
  String? lastDate;

  @override
  Future<GameResult?> getDaily(String dictionary, String date) async {
    lastDate = date;
    return null;
  }

  @override
  Future<bool?> get isFirstEnter async => false;

  @override
  Future<void> setDailyBoard(String dictionary, String date, GameResult savedResult) async {}

  @override
  Future<void> setFirstEnter() async {}
}
