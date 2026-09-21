import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordly/src/feature/game/data/game_datasource.dart';
import 'package:wordly/src/feature/game/data/game_result_board_codec.dart';
import 'package:wordly/src/feature/game/model/game_result.dart';
import 'package:wordly/src/feature/level/data/database/app_database.dart';
import 'package:wordly/src/feature/statistic/data/statistic_codec.dart';
import 'package:wordly/src/feature/statistic/data/statistic_datasource.dart';
import 'package:wordly/src/feature/statistic/data/statistics_repository.dart';
import 'package:wordly/src/feature/statistic/model/game_statistic.dart';

/// Daily boards and their statistics commit together in the progress database.
final class DailyStore({required final AppDatabase database, required final SharedPreferencesAsync preferences}) {
  static const _boardCodec = GameResultBoardCodec();
  static const _statisticCodec = StatisticCodec();

  Future<void> importLegacyStatistics() async {
    for (final language in ['ru', 'en']) {
      await database.durableTransaction(() async {
        final key = 'daily-statistics-shared-preferences-v1/$language';
        final QueryRow? marker = await database
            .customSelect(
              'SELECT version FROM migration_markers WHERE migration_key = ?',
              variables: [Variable<String>(key)],
            )
            .getSingleOrNull();
        if (marker != null) {
          return;
        }
        final GameStatistic statistic = await LegacyStatisticDatasource(sharedPreferences: preferences).read(language);
        await _saveStatistic(language, statistic);
        await database.customStatement('INSERT INTO migration_markers(migration_key, version) VALUES (?, 1)', [key]);
      });
    }
  }

  Future<GameResult?> getDaily(String language, String date) async {
    final QueryRow? row = await database
        .customSelect(
          'SELECT result_json FROM daily_games WHERE dictionary_code = ? AND date_key = ?',
          variables: [Variable<String>(language), Variable<String>(date)],
        )
        .getSingleOrNull();
    if (row == null) {
      return null;
    }
    return _boardCodec.decode(jsonDecode(row.read<String>('result_json')) as Map<String, dynamic>);
  }

  Future<void> saveDaily(String language, String date, GameResult result) => database.durableTransaction(() async {
    final GameResult? previous = await getDaily(language, date);
    // Retrying a committed completion, even after restart, cannot count it twice.
    if (previous?.isWin != null) {
      return;
    }
    if (result.isWin != null) {
      final GameStatistic statistic = await readStatistic(language);
      await _saveStatistic(
        language,
        updatedStatistic(statistic, isWin: result.isWin!, attempt: result.board.length ~/ 5),
      );
    }
    await _writeBoard(language, date, result);
  });

  Future<void> _writeBoard(String language, String date, GameResult result) async {
    final dated = GameResult(
      secretWord: result.secretWord,
      board: result.board,
      isWin: result.isWin,
      dailyDate: DateFormat('dd-MM-yyyy').parseStrict(date, true),
    );
    await database.customStatement(
      'INSERT INTO daily_games(dictionary_code, date_key, result_json) VALUES (?, ?, ?) '
      'ON CONFLICT(dictionary_code, date_key) DO UPDATE SET result_json = excluded.result_json',
      [language, date, jsonEncode(_boardCodec.encode(dated))],
    );
  }

  Future<GameStatistic> readStatistic(String language) async {
    final QueryRow? row = await database
        .customSelect(
          'SELECT statistic_json FROM daily_statistics WHERE dictionary_code = ?',
          variables: [Variable<String>(language)],
        )
        .getSingleOrNull();
    if (row == null) {
      return const GameStatistic(wins: 0, loses: 0, streak: 0, maxStreak: 0, attempts: GameStatistic.zeroAttempts);
    }
    return _statisticCodec.decode(jsonDecode(row.read<String>('statistic_json')) as Map<String, dynamic>);
  }

  Future<void> _saveStatistic(String language, GameStatistic statistic) => database.customStatement(
    'INSERT INTO daily_statistics(dictionary_code, statistic_json) VALUES (?, ?) '
    'ON CONFLICT(dictionary_code) DO UPDATE SET statistic_json = excluded.statistic_json',
    [language, jsonEncode(_statisticCodec.encode(statistic))],
  );
}

final class SqliteGameDatasource({required final DailyStore store, required final SharedPreferencesAsync preferences})
    implements IGameDatasource {
  @override
  Future<GameResult?> getDaily(String dictionary, String date) => store.getDaily(dictionary, date);

  @override
  Future<void> setDailyBoard(String dictionary, String date, GameResult savedResult) =>
      store.saveDaily(dictionary, date, savedResult);

  @override
  Future<bool?> get isFirstEnter => preferences.getBool('game.isFirstEnter');

  @override
  Future<void> setFirstEnter() => preferences.setBool('game.isFirstEnter', false);
}

final class SqliteStatisticDatasource({required final DailyStore store}) implements IStatisticDatasource {
  @override
  Future<GameStatistic> read(String dictionary) => store.readStatistic(dictionary);
}
