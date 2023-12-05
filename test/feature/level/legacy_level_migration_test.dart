import 'dart:convert';
import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wordly/src/feature/level/data/database/app_database.dart';
import 'package:wordly/src/feature/level/data/migration/legacy_level_migration.dart';

void main() {
  late AppDatabase database;

  setUp(() => database = AppDatabase(NativeDatabase.memory()));
  tearDown(() => database.close());

  test('imports 747 results and creates gaps only through level 949', () async {
    final history = List<String>.generate(747, (index) => jsonEncode({'word': 'word$index', 'isWin': index.isEven}));
    final store = _LegacyStore({
      'level_en': history,
      'game.board.en.1': jsonEncode({'secretWord': 'level950', 'lvl': 950, 'board': <Object?>[]}),
    });

    final LegacyLevelMigrationReport report = await LegacyLevelMigration(
      database: database,
      legacyStore: store,
    ).runForDictionary(const Locale('en'));

    final List<LevelResultRow> rows =
        await (database.select(database.levelResults)
              ..where((row) => row.dictionaryCode.equals('en'))
              ..orderBy([(row) => OrderingTerm.asc(row.levelNumber)]))
            .get();
    final LevelProgressRow progress = await database.select(database.levelProgressEntries).getSingle();
    expect(report.importedRealResults, 747);
    expect(report.placeholders, 202);
    expect(rows, hasLength(949));
    expect(rows.take(747).every((row) => row.secretWord != null && row.isWin != null), isTrue);
    expect(rows.skip(747).every((row) => row.secretWord == null && row.isWin == null), isTrue);
    expect(rows.last.levelNumber, 949);
    expect(progress.levelNumber, 950);
    expect(rows.where((row) => row.levelNumber == 950), isEmpty);
  });

  test('a repeated migration is skipped and does not duplicate rows', () async {
    final store = _LegacyStore({
      'level.en': jsonEncode({
        'levels': [
          {'secretWord': 'first', 'win': true, 'lvl': 1},
        ],
      }),
      'game.board.en.1': jsonEncode({'secretWord': 'second', 'lvl': 2, 'board': <Object?>[]}),
    });
    final migration = LegacyLevelMigration(database: database, legacyStore: store);

    await migration.runForDictionary(const Locale('en'));
    final LegacyLevelMigrationReport second = await migration.runForDictionary(const Locale('en'));

    expect(second.skipped, isTrue);
    expect(await database.select(database.levelResults).get(), hasLength(1));
    expect(await database.select(database.migrationMarkers).get(), hasLength(1));
  });

  test('continues past damaged items and resolves conflicting duplicates', () async {
    final List<String> warnings = [];
    final store = _LegacyStore({
      'level_en': [
        jsonEncode({'word': 'old', 'isWin': false}),
        '{broken',
        jsonEncode({'word': 'third', 'isWin': true}),
      ],
      'level.en': jsonEncode({
        'levels': [
          {'secretWord': 'new', 'win': true, 'lvl': 1},
          {'secretWord': 'second', 'win': false, 'lvl': 2},
        ],
      }),
      'game.board.en.1': jsonEncode({'secretWord': 'fourth', 'lvl': 4, 'board': <Object?>[]}),
    });

    final LegacyLevelMigrationReport report = await LegacyLevelMigration(
      database: database,
      legacyStore: store,
      logWarning: (message, {error, stackTrace}) => warnings.add(message),
    ).runForDictionary(const Locale('en'));

    final List<LevelResultRow> rows =
        await (database.select(database.levelResults)
              ..where((row) => row.dictionaryCode.equals('en'))
              ..orderBy([(row) => OrderingTerm.asc(row.levelNumber)]))
            .get();
    expect(report.rejectedEntries, 1);
    expect(report.conflicts, 1);
    expect(rows.map((row) => row.secretWord), ['new', 'second', 'third']);
    expect(rows.first.isWin, isTrue);
    expect(warnings, isNotEmpty);
  });

  test('keeps English and Russian data and markers isolated', () async {
    final store = _LegacyStore({
      'level_en': [
        jsonEncode({'word': 'english', 'isWin': true}),
      ],
      'level_ru': [
        jsonEncode({'word': 'russian', 'isWin': false}),
      ],
      'game.board.en.1': jsonEncode({'secretWord': 'en2', 'lvl': 2, 'board': <Object?>[]}),
      'game.board.ru.1': jsonEncode({'secretWord': 'ru2', 'lvl': 2, 'board': <Object?>[]}),
    });

    await LegacyLevelMigration(database: database, legacyStore: store).run();

    final List<LevelResultRow> results = await database.select(database.levelResults).get();
    final List<MigrationMarkerRow> markers = await database.select(database.migrationMarkers).get();
    expect(results.where((row) => row.dictionaryCode == 'en').single.secretWord, 'english');
    expect(results.where((row) => row.dictionaryCode == 'ru').single.secretWord, 'russian');
    expect(markers.map((row) => row.migrationKey).toSet(), {'legacy_level.en', 'legacy_level.ru'});
  });

  test('a crash before marker rolls back import and a later run succeeds', () async {
    final store = _LegacyStore({
      'level_en': [
        jsonEncode({'word': 'first', 'isWin': true}),
      ],
      'game.board.en.1': jsonEncode({'secretWord': 'second', 'lvl': 2, 'board': <Object?>[]}),
    });
    final migration = LegacyLevelMigration(database: database, legacyStore: store);
    await database.customStatement('''
      CREATE TRIGGER reject_migration_marker
      BEFORE INSERT ON migration_markers
      BEGIN
        SELECT RAISE(FAIL, 'injected marker failure');
      END
    ''');

    await expectLater(migration.runForDictionary(const Locale('en')), throwsA(isA<SqliteException>()));
    expect(await database.select(database.levelResults).get(), isEmpty);
    expect(await database.select(database.levelProgressEntries).get(), isEmpty);
    expect(await database.select(database.migrationMarkers).get(), isEmpty);

    await database.customStatement('DROP TRIGGER reject_migration_marker');
    await migration.runForDictionary(const Locale('en'));
    expect(await database.select(database.levelResults).get(), hasLength(1));
    expect(await database.select(database.migrationMarkers).get(), hasLength(1));
  });
}

final class const _LegacyStore(final Map<String, Object?> values) implements LegacyLevelStore {
  @override
  Future<Map<String, Object?>> readAll(Set<String> keys) async => {
    for (final String key in keys)
      if (values.containsKey(key)) key: values[key],
  };
}
