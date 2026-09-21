import 'dart:ui' show Locale;

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart' show KeyEvent, LogicalKeyboardKey;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wordly/src/feature/game/data/game_repository.dart';
import 'package:wordly/src/feature/game/model/game_mode.dart';
import 'package:wordly/src/feature/game/model/game_result.dart';
import 'package:wordly/src/feature/game/model/hard_mode.dart';
import 'package:wordly/src/feature/game/model/keyboard.dart';
import 'package:wordly/src/feature/game/model/letter_info.dart';
import 'package:wordly/src/feature/game/model/word_error.dart';
import 'package:wordly/src/feature/level/data/level_repository.dart';

part 'game_bloc.freezed.dart';
part 'game_event.dart';
part 'game_state.dart';

final class GameBloc({
  required Locale dictionary,
  required final IGameRepository _gameRepository,
  required final ILevelRepository _levelRepository,
  required GameResult? savedResult,
  final bool Function()? isHardMode,
  final DateTime Function() clock = DateTime.now,
}) extends Bloc<GameEvent, GameState> {
  this
    : super(
        _stateBySavedResult(
          savedResult,
          dictionary,
          GameMode.daily,
          _gameRepository.generateSecretWord(dictionary, date: savedResult?.dailyDate ?? clock()),
        ),
      ) {
    _dailyDate = utcDate(savedResult?.dailyDate ?? clock());
    on<GameEvent>((event, emit) async {
      if (event is _GameRefreshDaily) {
        await _refreshDaily(emit);
        return;
      }
      if (state is GamePersistenceFailure &&
          (state as GamePersistenceFailure).operation == GamePersistenceOperation.loadGame &&
          event is _GameChangeDictionary) {
        await _loadGame(state.gameMode, event.dictionary, emit);
        return;
      }
      if (state.isPersistenceFailure && event is! _GameRetryLevelPersistence) {
        return;
      }
      if (state.gameMode == GameMode.daily &&
          event is! _GameRetryLevelPersistence &&
          event is! _GameChangeDictionary &&
          event is! _GameChangeGameMode &&
          await _refreshDaily(emit)) {
        return;
      }
      switch (event) {
        case final _GameChangeDictionary e:
          await _changeDictionary(e, emit);
        case final _GameChangeGameMode e:
          await _changeGameMode(e, emit);
        case final _GameResetBoard e:
          await _resetBoard(e, emit);
        case final _GameLetterPressed e:
          _letterPressed(e, emit);
        case final _GameEnterPressed e:
          await _enterPressed(e, emit);
        case final _GameRetryLevelPersistence e:
          await _retryLevelPersistence(e, emit);
        case final _GameDeletePressed e:
          _deletePressed(e, emit);
        case final _GameDeleteLongPressed e:
          _deleteLongPressed(e, emit);
        case final _GameListenKeyEvent e:
          _listenKeyEvent(e, emit);
        case _GameRefreshDaily():
          break;
      }
    }, transformer: (events, mapper) => events.asyncExpand(mapper));
  }

  late DateTime _dailyDate;

  DateTime get dailyDate => _dailyDate;

  static DateTime utcDate(DateTime time) {
    final DateTime utc = time.toUtc();
    return DateTime.utc(utc.year, utc.month, utc.day);
  }

  Future<bool> _refreshDaily(Emitter<GameState> emit) async {
    final DateTime today = utcDate(clock());
    if (state.gameMode != GameMode.daily || state.isPersistenceFailure || today == _dailyDate) {
      return false;
    }
    try {
      final GameResult? saved = await _gameRepository.getDaily(state.dictionary, today);
      final String word = _gameRepository.generateSecretWord(state.dictionary, date: today);
      _dailyDate = today;
      emit(_stateBySavedResult(saved, state.dictionary, GameMode.daily, word));
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        _buildPersistenceFailureState(
          operation: GamePersistenceOperation.loadDaily,
          pendingProgress: GameResult(secretWord: state.secretWord, board: state.board),
          retryCount: 0,
        ),
      );
    }
    return true;
  }

  static const int _wordLength = 5;
  static const int _maxWords = 6;
  static const int _maxLetters = _wordLength * _maxWords;

  GameState _buildIdleState({
    List<LetterInfo>? board,
    Map<String, LetterStatus>? statuses,
    bool? gameCompleted,
    String? secretWord,
    GameMode? gameMode,
    Locale? dictionary,
    int? lvlNumber,
  }) {
    return GameState.idle(
      dictionary: dictionary ?? state.dictionary,
      secretWord: secretWord ?? state.secretWord,
      gameMode: gameMode ?? state.gameMode,
      gameCompleted: gameCompleted ?? state.gameCompleted,
      board: board ?? state.board,
      statuses: statuses ?? state.statuses,
      lvlNumber: lvlNumber ?? state.lvlNumber,
    );
  }

  GameState _buildFailureState({required WordError error}) {
    return GameState.failure(
      dictionary: state.dictionary,
      secretWord: state.secretWord,
      gameMode: state.gameMode,
      gameCompleted: state.gameCompleted,
      board: state.board,
      statuses: state.statuses,
      error: error,
      lvlNumber: state.lvlNumber,
    );
  }

  GameState _buildWinState({required List<LetterInfo> board, required Map<String, LetterStatus> statuses}) {
    return GameState.win(
      dictionary: state.dictionary,
      secretWord: state.secretWord,
      gameMode: state.gameMode,
      gameCompleted: true,
      board: board,
      statuses: statuses,
      lvlNumber: state.lvlNumber,
    );
  }

  GameState _buildLossState({required List<LetterInfo> board, required Map<String, LetterStatus> statuses}) {
    return GameState.loss(
      dictionary: state.dictionary,
      secretWord: state.secretWord,
      gameMode: state.gameMode,
      gameCompleted: true,
      board: board,
      statuses: statuses,
      lvlNumber: state.lvlNumber,
    );
  }

  Future<void> _saveDailyResult({
    required List<LetterInfo> board,
    required Map<String, LetterStatus> statuses,
    required Emitter<GameState> emit,
    bool? isWin,
    int retryCount = 0,
  }) async {
    final result = GameResult(secretWord: state.secretWord, board: board, isWin: isWin, dailyDate: _dailyDate);
    try {
      await _gameRepository.setDailyBoard(state.dictionary, _dailyDate, result);
      final GameResult saved = await _gameRepository.getDaily(state.dictionary, _dailyDate) ?? result;
      emit(_stateBySavedResult(saved, state.dictionary, GameMode.daily, saved.secretWord));
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        _buildPersistenceFailureState(
          operation: GamePersistenceOperation.saveDaily,
          pendingProgress: result,
          pendingIsWin: isWin,
          board: board,
          statuses: statuses,
          retryCount: retryCount,
        ),
      );
    }
  }

  Future<void> _saveLevelProgress({required List<LetterInfo> board, required Emitter<GameState> emit}) async {
    final progress = GameResult(secretWord: state.secretWord, board: board, lvlNumber: state.lvlNumber);
    try {
      await _levelRepository.saveCurrentProgress(state.dictionary, progress);
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        _buildPersistenceFailureState(
          operation: GamePersistenceOperation.saveLevelProgress,
          pendingProgress: progress,
          retryCount: 0,
        ),
      );
    }
  }

  Future<void> _completeLevel({
    required bool isWin,
    required List<LetterInfo> board,
    required Map<String, LetterStatus> statuses,
    required Emitter<GameState> emit,
  }) async {
    final int currentLevel = state.lvlNumber ?? 1;
    final int nextLevel = currentLevel + 1;
    final completed = GameResult(secretWord: state.secretWord, lvlNumber: currentLevel, isWin: isWin, board: board);
    final nextProgress = GameResult(
      secretWord: _gameRepository.generateSecretWord(state.dictionary, levelNumber: nextLevel),
      lvlNumber: nextLevel,
    );
    try {
      await _levelRepository.completeLevel(
        dictionary: state.dictionary,
        completedLevel: completed,
        nextLevel: nextProgress,
      );
      emit(
        isWin ? _buildWinState(board: board, statuses: statuses) : _buildLossState(board: board, statuses: statuses),
      );
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        _buildPersistenceFailureState(
          operation: GamePersistenceOperation.completeLevel,
          pendingProgress: nextProgress,
          completedLevel: completed,
          pendingIsWin: isWin,
          board: board,
          statuses: statuses,
          retryCount: 0,
        ),
      );
    }
  }

  GameState _buildPersistenceFailureState({
    required GamePersistenceOperation operation,
    required GameResult pendingProgress,
    required int retryCount,
    GameResult? completedLevel,
    bool? pendingIsWin,
    List<LetterInfo>? board,
    Map<String, LetterStatus>? statuses,
  }) => GameState.persistenceFailure(
    dictionary: state.dictionary,
    secretWord: state.secretWord,
    gameMode: state.gameMode,
    gameCompleted: false,
    board: board ?? state.board,
    statuses: statuses ?? state.statuses,
    lvlNumber: state.lvlNumber,
    operation: operation,
    pendingProgress: pendingProgress,
    completedLevel: completedLevel,
    pendingIsWin: pendingIsWin,
    retryCount: retryCount,
  );

  void _emitFailureThenIdle(Emitter<GameState> emit, WordError error) {
    emit(_buildFailureState(error: error));
    emit(_buildIdleState());
  }

  void _listenKeyEvent(_GameListenKeyEvent event, Emitter<GameState> emit) {
    final KeyEvent key = event.keyEvent;
    if (key.logicalKey == LogicalKeyboardKey.enter) {
      add(const GameEvent.enterPressed());
      return;
    }

    if (key.logicalKey == LogicalKeyboardKey.delete || key.logicalKey == LogicalKeyboardKey.backspace) {
      add(const GameEvent.deletePressed());
      return;
    }

    final String? letter = GameKeyboardKey.toLetter(key.logicalKey, state.dictionary);
    if (letter != null) {
      add(GameEvent.letterPressed(letter));
      return;
    }
  }

  Future<void> _loadGame(GameMode mode, Locale dictionary, Emitter<GameState> emit, {int retryCount = 0}) async {
    final DateTime date = utcDate(clock());
    try {
      final GameResult? saved = mode == GameMode.daily
          ? await _gameRepository.getDaily(dictionary, date)
          : await _levelRepository.getCurrentProgress(dictionary);
      final String word = _gameRepository.generateSecretWord(
        dictionary,
        date: date,
        levelNumber: mode == GameMode.daily ? 0 : saved?.lvlNumber ?? 1,
      );
      if (mode == GameMode.daily) {
        _dailyDate = date;
      }
      emit(_stateBySavedResult(saved, dictionary, mode, word));
    } on Object catch (error, stack) {
      addError(error, stack);
      // The selected dictionary is already persisted. Never expose a board from
      // the previous dictionary while the selected game's load is pending.
      emit(
        GameState.persistenceFailure(
          dictionary: dictionary,
          secretWord: '',
          gameMode: mode,
          gameCompleted: false,
          board: const [],
          statuses: const {},
          lvlNumber: null,
          operation: GamePersistenceOperation.loadGame,
          pendingProgress: const GameResult(secretWord: ''),
          completedLevel: null,
          pendingIsWin: null,
          retryCount: retryCount,
        ),
      );
    }
  }

  Future<void> _changeDictionary(_GameChangeDictionary event, Emitter<GameState> emit) async {
    if (state.dictionary != event.dictionary) {
      await _loadGame(state.gameMode, event.dictionary, emit);
    }
  }

  Future<void> _changeGameMode(_GameChangeGameMode event, Emitter<GameState> emit) async {
    if (state.gameMode != event.gameMode) {
      await _loadGame(event.gameMode, state.dictionary, emit);
    }
  }

  Future<void> _resetBoard(_GameResetBoard event, Emitter<GameState> emit) async {
    if (event.gameMode == GameMode.daily) {
      await _refreshDaily(emit);
      return;
    }
    await _loadNextLevel(emit);
  }

  Future<void> _loadNextLevel(Emitter<GameState> emit, {int retryCount = 0}) async {
    try {
      GameResult? progress = await _levelRepository.getCurrentProgress(state.dictionary);
      if (progress == null) {
        final int nextLevel = (state.lvlNumber ?? 0) + 1;
        progress = GameResult(
          secretWord: _gameRepository.generateSecretWord(state.dictionary, levelNumber: nextLevel),
          lvlNumber: nextLevel,
        );
        await _levelRepository.saveCurrentProgress(state.dictionary, progress);
      }
      emit(_stateBySavedResult(progress, state.dictionary, GameMode.lvl, progress.secretWord));
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        _buildPersistenceFailureState(
          operation: GamePersistenceOperation.loadNextLevel,
          pendingProgress: GameResult(secretWord: state.secretWord, lvlNumber: state.lvlNumber, board: state.board),
          retryCount: retryCount,
        ),
      );
    }
  }

  void _letterPressed(_GameLetterPressed event, Emitter<GameState> emit) {
    if (state.isInputBlocked) {
      return;
    }
    if (state.board.length >= _maxLetters) {
      return;
    }
    if (state.board.isNotEmpty &&
        state.board.length % _wordLength == 0 &&
        state.board[state.currentWordIndex * _wordLength].status == LetterStatus.unknown) {
      return;
    }
    emit(_buildIdleState(board: List.of(state.board)..add(LetterInfo(letter: event.key.toLowerCase()))));
  }

  void _deletePressed(_GameDeletePressed event, Emitter<GameState> emit) {
    if (state.isInputBlocked) {
      return;
    }
    if (state.board.length <= state.currentWordIndex * _wordLength ||
        state.board[state.currentWordIndex * _wordLength].status != LetterStatus.unknown) {
      return;
    }
    emit(_buildIdleState(board: List.of(state.board)..removeLast()));
  }

  void _deleteLongPressed(_GameDeleteLongPressed event, Emitter<GameState> emit) {
    if (state.isInputBlocked) {
      return;
    }
    if (state.board.length <= state.currentWordIndex * _wordLength ||
        state.board[state.currentWordIndex * _wordLength].status != LetterStatus.unknown) {
      return;
    }
    final List<LetterInfo> board = List.of(state.board);
    emit(_buildIdleState(board: board..removeRange(state.currentWordIndex * _wordLength, board.length)));
  }

  Future<void> _enterPressed(_GameEnterPressed event, Emitter<GameState> emit) async {
    if (state.isInputBlocked) {
      return;
    }
    if (state.board.isEmpty || state.board.length % _wordLength != 0) {
      _emitFailureThenIdle(emit, WordError.tooShort);
      return;
    }
    final List<String> word = state.board
        .slice(state.currentWordIndex * _wordLength, state.board.length)
        .map((l) => l.letter)
        .toList(growable: false);
    final String currentWord = word.join();
    // An existing game must remain solvable after a dictionary update.
    if (currentWord != state.secretWord && !_gameRepository.containsWord(state.dictionary, currentWord)) {
      _emitFailureThenIdle(emit, WordError.notFound);
      return;
    }
    if (isHardMode?.call() ?? false) {
      final WordError? error = validateHardMode(
        state.board.take(state.currentWordIndex * _wordLength).toList(growable: false),
        word,
      );
      if (error != null) {
        _emitFailureThenIdle(emit, error);
        return;
      }
    }
    if (currentWord == state.secretWord) {
      final Iterable<LetterInfo> correctWord = word.map((e) => LetterInfo(letter: e, status: LetterStatus.correctSpot));
      final List<LetterInfo> newBoard = List.of(state.board)
        ..replaceRange(state.currentWordIndex * _wordLength, state.board.length, correctWord);
      final Map<String, LetterStatus> newStatuses = Map.of(state.statuses);
      for (final e in word) {
        newStatuses[e] = LetterStatus.correctSpot;
      }
      switch (state.gameMode) {
        case GameMode.daily:
          await _saveDailyResult(board: newBoard, statuses: newStatuses, emit: emit, isWin: true);
        case GameMode.lvl:
          await _completeLevel(isWin: true, board: newBoard, statuses: newStatuses, emit: emit);
      }

      return;
    }
    final resultWord = <LetterInfo>[];
    final secretWordDictionary = <String, int>{};
    for (var i = 0; i < word.length; i++) {
      resultWord.add(
        LetterInfo(
          letter: word[i],
          status: state.secretWord[i] == word[i] ? LetterStatus.correctSpot : LetterStatus.notInWord,
        ),
      );
      if (state.secretWord[i] != word[i]) {
        if (secretWordDictionary.containsKey(state.secretWord[i])) {
          secretWordDictionary[state.secretWord[i]] = secretWordDictionary[state.secretWord[i]]! + 1;
        } else {
          secretWordDictionary[state.secretWord[i]] = 1;
        }
      }
    }
    for (var i = 0; i < resultWord.length; i++) {
      if (resultWord[i].status == LetterStatus.correctSpot) {
        continue;
      }
      if (secretWordDictionary.containsKey(resultWord[i].letter) && secretWordDictionary[resultWord[i].letter]! > 0) {
        resultWord[i] = LetterInfo(letter: resultWord[i].letter, status: LetterStatus.wrongSpot);
        secretWordDictionary[resultWord[i].letter] = secretWordDictionary[resultWord[i].letter]! - 1;
      }
    }
    final List<LetterInfo> newBoard = List.of(state.board)
      ..replaceRange(state.currentWordIndex * _wordLength, state.board.length, resultWord);
    final Map<String, LetterStatus> newStatuses = Map.of(state.statuses);
    for (final e in resultWord) {
      if (!newStatuses.containsKey(e.letter) ||
          newStatuses.containsKey(e.letter) && newStatuses[e.letter]! < e.status) {
        newStatuses[e.letter] = e.status;
      }
    }
    if (state.currentWordIndex >= _maxWords - 1) {
      switch (state.gameMode) {
        case GameMode.daily:
          await _saveDailyResult(board: newBoard, statuses: newStatuses, emit: emit, isWin: false);
        case GameMode.lvl:
          await _completeLevel(isWin: false, board: newBoard, statuses: newStatuses, emit: emit);
      }
    } else {
      switch (state.gameMode) {
        case GameMode.daily:
          await _saveDailyResult(board: newBoard, statuses: newStatuses, emit: emit);
        case GameMode.lvl:
          emit(_buildIdleState(board: newBoard, statuses: newStatuses));
          await _saveLevelProgress(board: newBoard, emit: emit);
      }
    }
  }

  Future<void> _retryLevelPersistence(_GameRetryLevelPersistence event, Emitter<GameState> emit) async {
    final GameState current = state;
    if (current is! GamePersistenceFailure) {
      return;
    }
    try {
      switch (current.operation) {
        case GamePersistenceOperation.loadNextLevel:
          await _loadNextLevel(emit, retryCount: current.retryCount + 1);
        case GamePersistenceOperation.loadGame:
          await _loadGame(current.gameMode, current.dictionary, emit, retryCount: current.retryCount + 1);
        case GamePersistenceOperation.saveDaily:
          await _saveDailyResult(
            board: current.pendingProgress.board,
            statuses: current.statuses,
            emit: emit,
            isWin: current.pendingIsWin,
            retryCount: current.retryCount + 1,
          );
        case GamePersistenceOperation.loadDaily:
          final DateTime today = utcDate(clock());
          final GameResult? saved = await _gameRepository.getDaily(current.dictionary, today);
          final String word = _gameRepository.generateSecretWord(current.dictionary, date: today);
          _dailyDate = today;
          emit(_stateBySavedResult(saved, current.dictionary, GameMode.daily, word));
        case GamePersistenceOperation.saveLevelProgress:
          await _levelRepository.saveCurrentProgress(current.dictionary, current.pendingProgress);
          emit(
            GameState.idle(
              dictionary: current.dictionary,
              secretWord: current.secretWord,
              gameMode: current.gameMode,
              gameCompleted: false,
              board: current.board,
              statuses: current.statuses,
              lvlNumber: current.lvlNumber,
            ),
          );
        case GamePersistenceOperation.completeLevel:
          final GameResult completed = current.completedLevel!;
          final bool isWin = current.pendingIsWin!;
          await _levelRepository.completeLevel(
            dictionary: current.dictionary,
            completedLevel: completed,
            nextLevel: current.pendingProgress,
          );
          emit(
            isWin
                ? GameState.win(
                    dictionary: current.dictionary,
                    secretWord: current.secretWord,
                    gameMode: current.gameMode,
                    gameCompleted: true,
                    board: current.board,
                    statuses: current.statuses,
                    lvlNumber: current.lvlNumber,
                  )
                : GameState.loss(
                    dictionary: current.dictionary,
                    secretWord: current.secretWord,
                    gameMode: current.gameMode,
                    gameCompleted: true,
                    board: current.board,
                    statuses: current.statuses,
                    lvlNumber: current.lvlNumber,
                  ),
          );
      }
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        GameState.persistenceFailure(
          dictionary: current.dictionary,
          secretWord: current.secretWord,
          gameMode: current.gameMode,
          gameCompleted: current.gameCompleted,
          board: current.board,
          statuses: current.statuses,
          lvlNumber: current.lvlNumber,
          operation: current.operation,
          pendingProgress: current.pendingProgress,
          completedLevel: current.completedLevel,
          pendingIsWin: current.pendingIsWin,
          retryCount: current.retryCount + 1,
        ),
      );
    }
  }
}

GameState _stateBySavedResult(GameResult? savedResult, Locale dictionary, GameMode gameMode, String secretWord) {
  if (savedResult == null || savedResult.isWin == null) {
    return GameState.idle(
      dictionary: dictionary,
      secretWord: savedResult?.secretWord ?? secretWord,
      gameMode: gameMode,
      gameCompleted: false,
      board: savedResult?.board ?? [],
      statuses: _boardToStatuses(savedResult?.board ?? []),
      lvlNumber: gameMode == GameMode.lvl ? savedResult?.lvlNumber ?? 1 : null,
    );
  }
  if (savedResult.isWin ?? false) {
    return GameState.win(
      dictionary: dictionary,
      secretWord: savedResult.secretWord,
      gameMode: gameMode,
      gameCompleted: true,
      board: savedResult.board,
      statuses: _boardToStatuses(savedResult.board),
      lvlNumber: gameMode == GameMode.lvl ? savedResult.lvlNumber ?? 1 : null,
    );
  }
  return GameState.loss(
    dictionary: dictionary,
    secretWord: savedResult.secretWord,
    gameMode: gameMode,
    gameCompleted: true,
    board: savedResult.board,
    statuses: _boardToStatuses(savedResult.board),
    lvlNumber: gameMode == GameMode.lvl ? savedResult.lvlNumber ?? 1 : null,
  );
}

Map<String, LetterStatus> _boardToStatuses(List<LetterInfo> board) {
  final statuses = <String, LetterStatus>{};
  for (final e in board) {
    final LetterStatus? previous = statuses[e.letter];
    if (previous == null || previous < e.status) {
      statuses[e.letter] = e.status;
    }
  }
  return statuses;
}
