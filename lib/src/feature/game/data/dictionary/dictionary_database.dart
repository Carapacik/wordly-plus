import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/services.dart';
import 'package:wordly/src/feature/game/data/dictionary/dictionary_file_stub.dart'
    if (dart.library.io) 'package:wordly/src/feature/game/data/dictionary/dictionary_file_native.dart';
import 'package:wordly/src/feature/game/data/dictionary/word_schedule.dart';

/// The schema is supplied by the asset; all access uses parameterized SQL.
base class DictionaryDatabase(super.executor) extends GeneratedDatabase {
  factory asset(String language) {
    if (language != 'ru' && language != 'en') {
      throw ArgumentError.value(language, 'language');
    }
    final asset = 'assets/dictionary/$language.sqlite';
    // Change this with each data release, independently of the schema version.
    final name = 'dictionary_${language}_20260920_3';
    final QueryExecutor executor = driftDatabase(
      name: name,
      native: DriftNativeOptions(databasePath: () => dictionaryFilePath(name, asset)),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
        initializeDatabase: () async {
          final ByteData bytes = await rootBundle.load(asset);
          return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
        },
      ),
    );
    return language == 'ru' ? _RussianDictionaryDatabase(executor) : _EnglishDictionaryDatabase(executor);
  }

  @override
  int get schemaVersion => 2;

  @override
  Iterable<TableInfo<Table, Object?>> get allTables => const [];

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (_) async => throw StateError('Dictionary asset has no schema version'),
    onUpgrade: (_, from, to) async => throw StateError('Unexpected dictionary schema: $from -> $to'),
    beforeOpen: (_) async {
      await customSelect('SELECT word, definition FROM words LIMIT 1').getSingle();
      await customStatement('PRAGMA query_only = ON');
    },
  );

  Future<List<String>> words() async => [
    for (final row in await customSelect('SELECT word FROM words ORDER BY word COLLATE BINARY').get())
      row.read<String>('word'),
  ];

  Future<String?> definition(String word) async {
    final QueryRow? row = await customSelect(
      'SELECT definition FROM words WHERE word = ?',
      variables: [Variable<String>(word)],
    ).getSingleOrNull();
    return row?.read<String>('definition');
  }

  Future<List<String>> scheduledWords({required bool daily}) async {
    // These identifiers are fixed SQL, never supplied by a caller as text.
    final position = daily ? 'daily_position' : 'level_position';
    final List<QueryRow> rows = await customSelect(
      'SELECT word, $position AS position FROM words WHERE $position IS NOT NULL ORDER BY $position',
    ).get();
    if (rows.isEmpty) {
      throw StateError('Empty dictionary schedule: $position');
    }
    for (var i = 0; i < rows.length; i++) {
      if (rows[i].read<int>('position') != i) {
        throw StateError('Noncontiguous dictionary schedule: $position');
      }
    }
    return [for (final row in rows) row.read<String>('word')];
  }

  Future<WordSchedule> schedule() async =>
      WordSchedule(levels: await scheduledWords(daily: false), daily: await scheduledWords(daily: true));
}

// Drift tracks duplicate instances by runtime type. These databases use separate
// files and executors, so give each language its own type while retaining the
// warning for accidental duplicate connections to the same language.
final class _RussianDictionaryDatabase(super.executor) extends DictionaryDatabase;

final class _EnglishDictionaryDatabase(super.executor) extends DictionaryDatabase;
