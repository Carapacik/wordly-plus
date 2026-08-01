import 'dart:convert';
import 'dart:ui' show Locale;

import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordly/src/feature/game/domain/model/game_result.dart';
import 'package:wordly/src/feature/game/domain/model/letter_info.dart';
import 'package:wordly/src/feature/level/data/database/app_database.dart';
import 'package:wordly/src/feature/level/domain/model/level_result.dart';

abstract interface class LegacyLevelStore {
  Future<Map<String, Object?>> readAll(Set<String> keys);
}

final class SharedPreferencesLegacyLevelStore implements LegacyLevelStore {
  const SharedPreferencesLegacyLevelStore(this._preferences);

  final SharedPreferencesAsync _preferences;

  @override
  Future<Map<String, Object?>> readAll(Set<String> keys) => _preferences.getAll(allowList: keys);
}

typedef LegacyMigrationLogger = void Function(String message, {Object? error, StackTrace? stackTrace});

final class LegacyLevelMigration {
  const LegacyLevelMigration({required this._database, required this._legacyStore, this.logWarning});

  static const int migrationVersion = 1;
  static const supportedDictionaries = [Locale('en'), Locale('ru')];

  final AppDatabase _database;
  final LegacyLevelStore _legacyStore;
  final LegacyMigrationLogger? logWarning;

  Future<List<LegacyLevelMigrationReport>> run() async {
    final reports = <LegacyLevelMigrationReport>[];
    for (final Locale dictionary in supportedDictionaries) {
      reports.add(await runForDictionary(dictionary));
    }
    return reports;
  }

  Future<LegacyLevelMigrationReport> runForDictionary(Locale dictionary) async {
    final String code = dictionary.languageCode;
    final markerKey = 'legacy_level.$code';
    final SimpleSelectStatement<$MigrationMarkersTable, MigrationMarkerRow> markerQuery = _database.select(
      _database.migrationMarkers,
    )..where((row) => row.migrationKey.equals(markerKey) & row.version.isBiggerOrEqualValue(migrationVersion));
    if (await markerQuery.getSingleOrNull() != null) {
      return LegacyLevelMigrationReport(dictionaryCode: code, skipped: true);
    }

    final historyKeys = ['level_$code', 'level$code', 'level.$code'];
    final progressKeys = ['board_${code}_1', 'game.board.$code.1'];
    final Map<String, Object?> rawValues = await _legacyStore.readAll({...historyKeys, ...progressKeys});
    final candidates = <int, _RankedResult>{};
    var rejected = 0;
    var conflicts = 0;

    for (var priority = 0; priority < historyKeys.length; priority++) {
      final String key = historyKeys[priority];
      final Object? raw = rawValues[key];
      if (raw == null) {
        continue;
      }
      final _ParsedHistory parsed = _parseHistory(raw, key);
      rejected += parsed.rejected;
      for (final LevelResult result in parsed.results) {
        final _RankedResult? existing = candidates[result.levelNumber];
        if (existing == null) {
          candidates[result.levelNumber] = _RankedResult(result, priority);
          continue;
        }
        if (existing.result == result) {
          continue;
        }
        conflicts++;
        final bool replace =
            !result.isUnavailable && existing.result.isUnavailable ||
            result.isUnavailable == existing.result.isUnavailable && priority >= existing.priority;
        if (replace) {
          candidates[result.levelNumber] = _RankedResult(result, priority);
        }
        _warn('Conflicting legacy result for $code level ${result.levelNumber}');
      }
    }

    GameResult? progress;
    for (final key in progressKeys) {
      final Object? raw = rawValues[key];
      if (raw == null) {
        continue;
      }
      try {
        progress = _parseProgress(raw);
      } on Object catch (error, stackTrace) {
        rejected++;
        _warn('Rejected legacy Level progress from $key', error: error, stackTrace: stackTrace);
      }
    }

    var placeholderCount = 0;
    await _database.transaction(() async {
      for (final _RankedResult ranked in candidates.values) {
        await _upsertMigratedResult(code, ranked.result);
      }

      if (progress != null) {
        final int currentLevel = progress.lvlNumber!;
        final SimpleSelectStatement<$LevelResultsTable, LevelResultRow> existingQuery = _database.select(
          _database.levelResults,
        )..where((row) => row.dictionaryCode.equals(code));
        final Set<int> existingLevels = (await existingQuery.get()).map((row) => row.levelNumber).toSet();
        for (var level = 1; level < currentLevel; level++) {
          if (existingLevels.add(level)) {
            await _database
                .into(_database.levelResults)
                .insert(
                  LevelResultsCompanion.insert(
                    dictionaryCode: code,
                    levelNumber: level,
                    secretWord: const Value(null),
                    isWin: const Value(null),
                  ),
                  mode: InsertMode.insertOrIgnore,
                );
            placeholderCount++;
          }
        }
        await _database
            .into(_database.levelProgressEntries)
            .insertOnConflictUpdate(
              LevelProgressEntriesCompanion.insert(
                dictionaryCode: code,
                levelNumber: currentLevel,
                secretWord: progress.secretWord,
                boardJson: jsonEncode(progress.board.map((entry) => entry.toJson()).toList(growable: false)),
              ),
            );
      }

      await _validate(code, candidates.values.map((entry) => entry.result), progress);
      await _database
          .into(_database.migrationMarkers)
          .insertOnConflictUpdate(MigrationMarkersCompanion.insert(migrationKey: markerKey, version: migrationVersion));
    });

    return LegacyLevelMigrationReport(
      dictionaryCode: code,
      importedRealResults: candidates.values.where((entry) => !entry.result.isUnavailable).length,
      placeholders: placeholderCount,
      rejectedEntries: rejected,
      conflicts: conflicts,
    );
  }

  _ParsedHistory _parseHistory(Object raw, String key) {
    try {
      final Object? container = raw is String ? jsonDecode(raw) : raw;
      final List<Object?> entries = switch (container) {
        final List<Object?> list => list,
        final Map<Object?, Object?> map when map['levels'] is List<Object?> => List<Object?>.from(
          map['levels']! as List<Object?>,
        ),
        _ => throw const FormatException('Unsupported Level history container'),
      };
      final results = <LevelResult>[];
      var rejected = 0;
      for (var index = 0; index < entries.length; index++) {
        try {
          final Object? decoded = entries[index] is String ? jsonDecode(entries[index]! as String) : entries[index];
          if (decoded is! Map) {
            throw const FormatException('Level entry is not an object');
          }
          final map = Map<String, Object?>.from(decoded);
          final Object? rawNumber = map['lvl'];
          final int levelNumber = rawNumber is int ? rawNumber : index + 1;
          if (levelNumber < 1) {
            throw const FormatException('Level number must be positive');
          }
          final Object? rawWord = map.containsKey('secretWord') ? map['secretWord'] : map['word'];
          final Object? rawWin = map.containsKey('win') ? map['win'] : map['isWin'];
          if (rawWord is String && rawWord.isNotEmpty && rawWin is bool) {
            results.add(LevelResult(levelNumber: levelNumber, secretWord: rawWord, isWin: rawWin));
          } else {
            results.add(LevelResult.unavailable(levelNumber: levelNumber));
          }
        } on Object catch (error, stackTrace) {
          rejected++;
          _warn('Rejected legacy Level history item $index from $key', error: error, stackTrace: stackTrace);
        }
      }
      return _ParsedHistory(results: results, rejected: rejected);
    } on Object catch (error, stackTrace) {
      _warn('Rejected legacy Level history container $key', error: error, stackTrace: stackTrace);
      return const _ParsedHistory(results: [], rejected: 1);
    }
  }

  GameResult _parseProgress(Object raw) {
    final Object? decoded = raw is String ? jsonDecode(raw) : raw;
    if (decoded is! Map) {
      throw const FormatException('Level progress is not an object');
    }
    final map = Map<String, Object?>.from(decoded);
    final Object? secretWord = map['secretWord'];
    final Object? levelNumber = map['lvl'];
    if (secretWord is! String || secretWord.isEmpty || levelNumber is! int || levelNumber < 1) {
      throw const FormatException('Level progress is missing required fields');
    }
    return GameResult(secretWord: secretWord, lvlNumber: levelNumber, board: _parseBoard(map['board']));
  }

  List<LetterInfo> _parseBoard(Object? rawBoard) {
    if (rawBoard == null || rawBoard == '') {
      return const [];
    }
    final Iterable<Object?> entries = switch (rawBoard) {
      final List<Object?> list => list,
      final String value => value.split('|').where((entry) => entry.trim().isNotEmpty).map(jsonDecode),
      _ => throw const FormatException('Unsupported Level board payload'),
    };
    return entries
        .map((entry) => LetterInfo.fromJson(Map<String, Object?>.from(entry! as Map<Object?, Object?>)))
        .toList(growable: false);
  }

  Future<void> _upsertMigratedResult(String code, LevelResult result) async {
    final SimpleSelectStatement<$LevelResultsTable, LevelResultRow> existingQuery = _database.select(
      _database.levelResults,
    )..where((row) => row.dictionaryCode.equals(code) & row.levelNumber.equals(result.levelNumber));
    final LevelResultRow? existing = await existingQuery.getSingleOrNull();
    if (existing?.secretWord != null || result.isUnavailable && existing != null) {
      return;
    }
    await _database
        .into(_database.levelResults)
        .insertOnConflictUpdate(
          LevelResultsCompanion.insert(
            dictionaryCode: code,
            levelNumber: result.levelNumber,
            secretWord: Value(result.secretWord),
            isWin: Value(result.isWin),
          ),
        );
  }

  Future<void> _validate(String code, Iterable<LevelResult> candidates, GameResult? progress) async {
    final SimpleSelectStatement<$LevelResultsTable, LevelResultRow> resultQuery = _database.select(
      _database.levelResults,
    )..where((row) => row.dictionaryCode.equals(code));
    final List<LevelResultRow> rows = await resultQuery.get();
    final Map<int, LevelResultRow> rowsByLevel = {for (final row in rows) row.levelNumber: row};
    if (rowsByLevel.length != rows.length || rows.any((row) => row.levelNumber < 1)) {
      throw StateError('Invalid migrated Level result keys for $code');
    }
    for (final LevelResult candidate in candidates.where((entry) => !entry.isUnavailable)) {
      final LevelResultRow? row = rowsByLevel[candidate.levelNumber];
      if (row == null || row.secretWord == null || row.isWin == null) {
        throw StateError('A valid legacy Level result was not imported for $code level ${candidate.levelNumber}');
      }
    }
    if (progress != null) {
      final SimpleSelectStatement<$LevelProgressEntriesTable, LevelProgressRow> progressQuery = _database.select(
        _database.levelProgressEntries,
      )..where((row) => row.dictionaryCode.equals(code));
      final LevelProgressRow? stored = await progressQuery.getSingleOrNull();
      if (stored == null || stored.levelNumber != progress.lvlNumber || stored.secretWord != progress.secretWord) {
        throw StateError('Migrated Level progress failed validation for $code');
      }
      if (rows.any((row) => row.levelNumber >= progress.lvlNumber! && row.secretWord == null)) {
        throw StateError('A placeholder was created for the current or future Level in $code');
      }
    }
  }

  void _warn(String message, {Object? error, StackTrace? stackTrace}) =>
      logWarning?.call(message, error: error, stackTrace: stackTrace);
}

final class LegacyLevelMigrationReport {
  const LegacyLevelMigrationReport({
    required this.dictionaryCode,
    this.importedRealResults = 0,
    this.placeholders = 0,
    this.rejectedEntries = 0,
    this.conflicts = 0,
    this.skipped = false,
  });

  final String dictionaryCode;
  final int importedRealResults;
  final int placeholders;
  final int rejectedEntries;
  final int conflicts;
  final bool skipped;
}

final class _RankedResult {
  const _RankedResult(this.result, this.priority);

  final LevelResult result;
  final int priority;
}

final class _ParsedHistory {
  const _ParsedHistory({required this.results, required this.rejected});

  final List<LevelResult> results;
  final int rejected;
}
