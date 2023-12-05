import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wordly/src/feature/game/domain/model/game_result.dart';
import 'package:wordly/src/feature/level/data/database/app_database.dart';
import 'package:wordly/src/feature/level/domain/model/level_result.dart';
import 'package:wordly/src/feature/level/domain/repositories/level_repository.dart';

void main() {
  const dictionary = Locale('en');
  late AppDatabase database;
  late LevelRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = LevelRepository(database: database);
  });
  tearDown(() => database.close());

  test('completeLevel commits result and next progress atomically', () async {
    await repository.saveCurrentProgress(dictionary, const GameResult(secretWord: 'first', lvlNumber: 1));
    await repository.completeLevel(
      dictionary: dictionary,
      completedLevel: const GameResult(secretWord: 'first', lvlNumber: 1, isWin: true),
      nextLevel: const GameResult(secretWord: 'second', lvlNumber: 2),
    );

    expect((await repository.getResults(dictionary)).single.secretWord, 'first');
    expect((await repository.getCurrentProgress(dictionary))!.secretWord, 'second');
  });

  test('rolls the result back when the second write fails', () async {
    await repository.saveCurrentProgress(dictionary, const GameResult(secretWord: 'first', lvlNumber: 1));
    await database.customStatement('''
      CREATE TRIGGER reject_next_progress
      BEFORE UPDATE ON level_progress
      BEGIN
        SELECT RAISE(FAIL, 'injected progress failure');
      END
    ''');

    await expectLater(
      repository.completeLevel(
        dictionary: dictionary,
        completedLevel: const GameResult(secretWord: 'first', lvlNumber: 1, isWin: true),
        nextLevel: const GameResult(secretWord: 'second', lvlNumber: 2),
      ),
      throwsA(isA<SqliteException>()),
    );

    expect(await repository.getResults(dictionary), isEmpty);
    expect((await repository.getCurrentProgress(dictionary))!.lvlNumber, 1);
  });

  test('retry is idempotent and conflicting or stale completion is rejected', () async {
    await repository.saveCurrentProgress(dictionary, const GameResult(secretWord: 'first', lvlNumber: 1));
    const completed = GameResult(secretWord: 'first', lvlNumber: 1, isWin: true);
    const next = GameResult(secretWord: 'second', lvlNumber: 2);
    await repository.completeLevel(dictionary: dictionary, completedLevel: completed, nextLevel: next);
    await repository.completeLevel(dictionary: dictionary, completedLevel: completed, nextLevel: next);

    expect(await repository.getResults(dictionary), hasLength(1));
    await expectLater(
      repository.completeLevel(
        dictionary: dictionary,
        completedLevel: const GameResult(secretWord: 'other', lvlNumber: 1, isWin: false),
        nextLevel: next,
      ),
      throwsStateError,
    );
    await expectLater(
      repository.completeLevel(
        dictionary: dictionary,
        completedLevel: const GameResult(secretWord: 'third', lvlNumber: 3, isWin: true),
        nextLevel: const GameResult(secretWord: 'fourth', lvlNumber: 4),
      ),
      throwsStateError,
    );
  });

  test('real completion replaces a placeholder but a placeholder never replaces real data', () async {
    await database
        .into(database.levelResults)
        .insert(
          LevelResultsCompanion.insert(
            dictionaryCode: 'en',
            levelNumber: 1,
            secretWord: const Value(null),
            isWin: const Value(null),
          ),
        );
    await repository.saveCurrentProgress(dictionary, const GameResult(secretWord: 'first', lvlNumber: 1));

    await repository.completeLevel(
      dictionary: dictionary,
      completedLevel: const GameResult(secretWord: 'first', lvlNumber: 1, isWin: true),
      nextLevel: const GameResult(secretWord: 'second', lvlNumber: 2),
    );

    final LevelResult result = (await repository.getResults(dictionary)).single;
    expect(result.secretWord, 'first');
    expect(result.isWin, isTrue);
  });
}
