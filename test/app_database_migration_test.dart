import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wordly/src/feature/level/data/database/app_database.dart';

void main() {
  for (final existingDailyTables in [false, true]) {
    test('upgrades version 1 with existing daily tables: $existingDailyTables', () async {
      final database = AppDatabase(
        NativeDatabase.memory(
          setup: (sqlite) {
            sqlite.execute('''
              CREATE TABLE level_results (
                dictionary_code TEXT NOT NULL,
                level_number INTEGER NOT NULL,
                secret_word TEXT,
                is_win INTEGER,
                PRIMARY KEY (dictionary_code, level_number)
              );
              CREATE TABLE level_progress (
                dictionary_code TEXT NOT NULL PRIMARY KEY,
                level_number INTEGER NOT NULL,
                secret_word TEXT NOT NULL,
                board_json TEXT NOT NULL
              );
              CREATE TABLE migration_markers (
                migration_key TEXT NOT NULL PRIMARY KEY,
                version INTEGER NOT NULL
              );
              INSERT INTO level_results VALUES ('en', 1, 'apple', 1);
              INSERT INTO level_progress VALUES ('en', 2, 'grape', '[]');
              INSERT INTO migration_markers VALUES ('legacy', 1);
              PRAGMA user_version = 1;
            ''');
            if (existingDailyTables) {
              sqlite.execute('''
                CREATE TABLE daily_games (
                  dictionary_code TEXT NOT NULL,
                  date_key TEXT NOT NULL,
                  result_json TEXT NOT NULL,
                  PRIMARY KEY (dictionary_code, date_key)
                );
                CREATE TABLE daily_statistics (
                  dictionary_code TEXT NOT NULL PRIMARY KEY,
                  statistic_json TEXT NOT NULL
                );
                INSERT INTO daily_games VALUES ('en', '21-09-2026', '{}');
                INSERT INTO daily_statistics VALUES ('en', '{"wins":7}');
              ''');
            }
          },
        ),
      );
      addTearDown(database.close);

      final List<DailyStatistic> statistics = await database.select(database.dailyStatistics).get();
      final List<DailyGame> games = await database.select(database.dailyGames).get();
      expect(statistics, hasLength(existingDailyTables ? 1 : 0));
      expect(games, hasLength(existingDailyTables ? 1 : 0));
      if (existingDailyTables) {
        expect(statistics.single.statisticJson, '{"wins":7}');
        expect(games.single.resultJson, '{}');
      }
      expect((await database.select(database.levelResults).getSingle()).secretWord, 'apple');
      expect((await database.select(database.levelProgressEntries).getSingle()).boardJson, '[]');
      expect((await database.select(database.migrationMarkers).getSingle()).migrationKey, 'legacy');
      expect((await database.customSelect('PRAGMA user_version').getSingle()).read<int>('user_version'), 2);
      await database.customStatement("INSERT INTO daily_statistics VALUES ('ru', '{}')");
      await database.customStatement("INSERT INTO daily_games VALUES ('ru', '21-09-2026', '{}')");
    });
  }
}
