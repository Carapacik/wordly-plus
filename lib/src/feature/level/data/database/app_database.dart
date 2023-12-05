import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('LevelResultRow')
class LevelResults() extends Table {
  TextColumn get dictionaryCode => text()();

  IntColumn get levelNumber => integer()();

  TextColumn get secretWord => text().nullable()();

  BoolColumn get isWin => boolean().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {dictionaryCode, levelNumber};

  @override
  List<String> get customConstraints => const [
    "CHECK (dictionary_code IN ('en', 'ru'))",
    'CHECK (level_number > 0)',
    'CHECK ((secret_word IS NULL AND is_win IS NULL) OR (secret_word IS NOT NULL AND is_win IS NOT NULL))',
  ];
}

@DataClassName('LevelProgressRow')
class LevelProgressEntries() extends Table {
  @override
  String get tableName => 'level_progress';

  TextColumn get dictionaryCode => text()();

  IntColumn get levelNumber => integer()();

  TextColumn get secretWord => text()();

  TextColumn get boardJson => text()();

  @override
  Set<Column<Object>> get primaryKey => {dictionaryCode};

  @override
  List<String> get customConstraints => const ["CHECK (dictionary_code IN ('en', 'ru'))", 'CHECK (level_number > 0)'];
}

@DataClassName('MigrationMarkerRow')
class MigrationMarkers() extends Table {
  TextColumn get migrationKey => text()();

  IntColumn get version => integer()();

  @override
  Set<Column<Object>> get primaryKey => {migrationKey};

  @override
  List<String> get customConstraints => const ['CHECK (version > 0)'];
}

@DriftDatabase(tables: [LevelResults, LevelProgressEntries, MigrationMarkers])
final class AppDatabase extends _$AppDatabase {
  new(super.e);

  new defaults()
    : super(
        driftDatabase(
          name: 'wordly_plus',
          web: DriftWebOptions(sqlite3Wasm: Uri.parse('sqlite3.wasm'), driftWorker: Uri.parse('drift_worker.js')),
        ),
      );

  @override
  int get schemaVersion => 1;
}
