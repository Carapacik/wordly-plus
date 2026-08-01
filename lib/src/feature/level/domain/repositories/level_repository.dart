import 'dart:convert';
import 'dart:ui' show Locale;

import 'package:drift/drift.dart';
import 'package:wordly/src/feature/game/domain/model/game_result.dart';
import 'package:wordly/src/feature/game/domain/model/letter_info.dart';
import 'package:wordly/src/feature/level/data/database/app_database.dart';
import 'package:wordly/src/feature/level/domain/model/level_result.dart';

abstract interface class ILevelRepository {
  Future<GameResult?> getCurrentProgress(Locale dictionary);

  Future<List<LevelResult>> getResults(Locale dictionary);

  Future<void> saveCurrentProgress(Locale dictionary, GameResult progress);

  Future<void> completeLevel({
    required Locale dictionary,
    required GameResult completedLevel,
    required GameResult nextLevel,
  });
}

final class LevelRepository implements ILevelRepository {
  const LevelRepository({required this._database});

  final AppDatabase _database;

  @override
  Future<GameResult?> getCurrentProgress(Locale dictionary) async {
    final SimpleSelectStatement<$LevelProgressEntriesTable, LevelProgressRow> query = _database.select(
      _database.levelProgressEntries,
    )..where((row) => row.dictionaryCode.equals(dictionary.languageCode));
    final LevelProgressRow? row = await query.getSingleOrNull();
    if (row == null) {
      return null;
    }
    return GameResult(secretWord: row.secretWord, lvlNumber: row.levelNumber, board: _decodeBoard(row.boardJson));
  }

  @override
  Future<List<LevelResult>> getResults(Locale dictionary) async {
    final SimpleSelectStatement<$LevelResultsTable, LevelResultRow> query = _database.select(_database.levelResults)
      ..where((row) => row.dictionaryCode.equals(dictionary.languageCode))
      ..orderBy([(row) => OrderingTerm.asc(row.levelNumber)]);
    final List<LevelResultRow> rows = await query.get();
    return rows
        .map((row) => LevelResult(levelNumber: row.levelNumber, secretWord: row.secretWord, isWin: row.isWin))
        .toList(growable: false);
  }

  @override
  Future<void> saveCurrentProgress(Locale dictionary, GameResult progress) async {
    final int levelNumber = _requiredLevelNumber(progress);
    await _database
        .into(_database.levelProgressEntries)
        .insertOnConflictUpdate(
          LevelProgressEntriesCompanion.insert(
            dictionaryCode: dictionary.languageCode,
            levelNumber: levelNumber,
            secretWord: progress.secretWord,
            boardJson: _encodeBoard(progress.board),
          ),
        );
  }

  @override
  Future<void> completeLevel({
    required Locale dictionary,
    required GameResult completedLevel,
    required GameResult nextLevel,
  }) async {
    final int completedNumber = _requiredLevelNumber(completedLevel);
    final int nextNumber = _requiredLevelNumber(nextLevel);
    final bool? isWin = completedLevel.isWin;
    if (isWin == null) {
      throw ArgumentError.value(completedLevel, 'completedLevel', 'A completed level must have an outcome');
    }
    if (nextNumber != completedNumber + 1) {
      throw ArgumentError.value(nextLevel, 'nextLevel', 'The next level must immediately follow the completed level');
    }

    await _database.transaction(() async {
      final SimpleSelectStatement<$LevelProgressEntriesTable, LevelProgressRow> progressQuery = _database.select(
        _database.levelProgressEntries,
      )..where((row) => row.dictionaryCode.equals(dictionary.languageCode));
      final LevelProgressRow? currentProgress = await progressQuery.getSingleOrNull();
      final bool isIdempotentRetry =
          currentProgress?.levelNumber == nextNumber &&
          currentProgress?.secretWord == nextLevel.secretWord &&
          currentProgress?.boardJson == _encodeBoard(nextLevel.board);
      if (currentProgress != null && currentProgress.levelNumber != completedNumber && !isIdempotentRetry) {
        throw StateError(
          'Cannot complete level $completedNumber while level ${currentProgress.levelNumber} is current',
        );
      }

      final SimpleSelectStatement<$LevelResultsTable, LevelResultRow> existingQuery = _database.select(
        _database.levelResults,
      )..where((row) => row.dictionaryCode.equals(dictionary.languageCode) & row.levelNumber.equals(completedNumber));
      final LevelResultRow? existing = await existingQuery.getSingleOrNull();
      if (existing != null && existing.secretWord != null) {
        if (existing.secretWord != completedLevel.secretWord || existing.isWin != isWin) {
          throw StateError('A conflicting real result already exists for level $completedNumber');
        }
      } else {
        await _database
            .into(_database.levelResults)
            .insertOnConflictUpdate(
              LevelResultsCompanion.insert(
                dictionaryCode: dictionary.languageCode,
                levelNumber: completedNumber,
                secretWord: Value(completedLevel.secretWord),
                isWin: Value(isWin),
              ),
            );
      }

      if (!isIdempotentRetry) {
        await _database
            .into(_database.levelProgressEntries)
            .insertOnConflictUpdate(
              LevelProgressEntriesCompanion.insert(
                dictionaryCode: dictionary.languageCode,
                levelNumber: nextNumber,
                secretWord: nextLevel.secretWord,
                boardJson: _encodeBoard(nextLevel.board),
              ),
            );
      }
    });
  }
}

int _requiredLevelNumber(GameResult result) {
  final int? number = result.lvlNumber;
  if (number == null || number < 1) {
    throw ArgumentError.value(result, 'result', 'A positive level number is required');
  }
  return number;
}

String _encodeBoard(List<LetterInfo> board) => jsonEncode(board.map((entry) => entry.toJson()).toList(growable: false));

List<LetterInfo> _decodeBoard(String rawBoard) {
  final Object? decoded = jsonDecode(rawBoard);
  if (decoded is! List) {
    throw const FormatException('Stored Level board is not a list');
  }
  return decoded.map((entry) => LetterInfo.fromJson(Map<String, Object?>.from(entry as Map))).toList(growable: false);
}
