import 'dart:developer' show log;
import 'dart:math' show Random;

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wordly/data/models.dart';
import 'package:wordly/data/repositories.dart';

part 'game_bloc.freezed.dart';
part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    required this.gameRepository,
    required this.statisticRepository,
    required this.levelsRepository,
    required DictionaryEnum dictionary,
  })  : _dictionary = dictionary,
        super(const GameState.initial()) {
    on<_KeyListenEvent>(_onKeyListen);
    on<_LetterPressedEvent>(_onLetterPressed);
    on<_DeletePressedEvent>(_onDeletePressed);
    on<_DeleteLongPressedEvent>(_onDeleteLongPressed);
    on<_EnterPressedEvent>(_onEnterPressed);
    on<_LoadGameEvent>(_onLoadGame);
    on<_ShareEvent>(_onShare);
    on<_ChangeDictionaryEvent>(_onChangeDictionary);
  }

  final ISaveGameRepository gameRepository;
  final ISaveStatisticRepository statisticRepository;
  final ISaveLevelsRepository levelsRepository;

  DictionaryEnum _dictionary;
  List<LetterInfo> _gridInfo = [];
  Map<KeyboardKeys, LetterStatus> _keyboardInfo = {};

  bool _isGameComplete = false;
  String _secretWord = '';
  int _currentWordIndex = 0;
  bool _isDailyMode = true;
  int _levelNumber = 0;

  int get levelNumber => _levelNumber;

  void _onKeyListen(
    _KeyListenEvent event,
    Emitter<GameState> emit,
  ) {
    if (event.keyDown.isKeyPressed(LogicalKeyboardKey.enter)) {
      add(const GameEvent.enterPressed());
      return;
    }

    if (event.keyDown.isKeyPressed(LogicalKeyboardKey.delete) ||
        event.keyDown.isKeyPressed(LogicalKeyboardKey.backspace)) {
      add(const GameEvent.deletePressed());
      return;
    }

    final letter = KeyboardKeys.fromLogicalKey(event.keyDown.logicalKey);
    if (letter != null) {
      add(GameEvent.letterPressed(letter));
      return;
    }
  }

  void _onLetterPressed(
    _LetterPressedEvent event,
    Emitter<GameState> emit,
  ) {
    if (_isGameComplete) {
      return;
    }
    if (_gridInfo.length < (_currentWordIndex + 1) * 5) {
      final newList = List<LetterInfo>.of(_gridInfo)
        ..add(LetterInfo(letter: event.letter.fromDictionary(_dictionary)!));
      _gridInfo = newList;
      emit(GameState.boardUpdate(newList));
    }
  }

  void _onDeletePressed(
    _DeletePressedEvent event,
    Emitter<GameState> emit,
  ) {
    if (_isGameComplete) {
      return;
    }
    if (_gridInfo.length > _currentWordIndex * 5) {
      final newList = List<LetterInfo>.of(_gridInfo)..removeLast();
      _gridInfo = newList;
      emit(GameState.boardUpdate(newList));
    }
  }

  void _onDeleteLongPressed(
    _DeleteLongPressedEvent event,
    Emitter<GameState> emit,
  ) {
    if (_isGameComplete) {
      return;
    }
    if (_gridInfo.length > _currentWordIndex * 5) {
      final newList = List<LetterInfo>.of(_gridInfo)
        ..removeRange(_currentWordIndex * 5, _gridInfo.length);
      _gridInfo = newList;
      emit(GameState.boardUpdate(newList));
    }
  }

  Future<void> _onEnterPressed(
    _EnterPressedEvent event,
    Emitter<GameState> emit,
  ) async {
    if (_isGameComplete) {
      return;
    }
    if (_gridInfo.isEmpty || _gridInfo.length % 5 != 0) {
      emit(const GameState.error(GameError.tooShort));
      return;
    }
    final word = _buildWord;
    if (!_dictionary.currentDictionary.containsKey(word)) {
      emit(const GameState.error(GameError.notFound));
      return;
    }
    // Win game
    if (word == _secretWord) {
      _gridInfo.replaceRange(
        _gridInfo.length - 5,
        _gridInfo.length,
        _colorTheWord,
      );
      _isGameComplete = true;

      final gameResult = GameResult(
        isWin: true,
        word: _secretWord,
        meaning: _dictionary.currentDictionary[_secretWord] ?? '',
      );
      await _saveResultAndBoard(gameResult);
      await _saveStatAndLvl(gameResult);

      emit(GameState.wordSubmit(board: _gridInfo, keyboard: _keyboardInfo));
      emit(GameState.complete(result: gameResult, isDaily: _isDailyMode));
      return;
    }

    // Lose game (attempts ended)
    if (_currentWordIndex == 5) {
      _gridInfo.replaceRange(
        _gridInfo.length - 5,
        _gridInfo.length,
        _colorTheWord,
      );
      _isGameComplete = true;

      final gameResult = GameResult(
        isWin: false,
        word: _secretWord,
        meaning: _dictionary.currentDictionary[_secretWord] ?? '',
      );
      await _saveResultAndBoard(gameResult);
      await _saveStatAndLvl(gameResult);

      emit(GameState.wordSubmit(board: _gridInfo, keyboard: _keyboardInfo));
      emit(GameState.complete(result: gameResult, isDaily: _isDailyMode));
      return;
    }

    // Other (game is not over)
    if (_dictionary.currentDictionary.containsKey(word)) {
      _gridInfo.replaceRange(
        _gridInfo.length - 5,
        _gridInfo.length,
        _colorTheWord,
      );
      final gameResult = GameResult(
        word: _secretWord,
        meaning: _dictionary.currentDictionary[_secretWord] ?? '',
      );
      await _saveResultAndBoard(gameResult);

      emit(GameState.wordSubmit(board: _gridInfo, keyboard: _keyboardInfo));
    }
  }

  Future<void> _onLoadGame(
    _LoadGameEvent event,
    Emitter<GameState> emit,
  ) async {
    // Daily
    if (event.isDaily) {
      _levelNumber = 0;
      _isDailyMode = true;
      _generateSecretWord();
      _gridInfo = await gameRepository.getDailyBoard(_dictionary) ?? [];
      _currentWordIndex = _gridInfo.length ~/ 5;
      final previousResult = await gameRepository.getDailyResult(_dictionary);
      if (previousResult != null && previousResult.word == _secretWord) {
        if (previousResult.isWin != null) {
          _isGameComplete = true;
          if (event.isFirst) {
            emit(
              GameState.complete(
                result: previousResult,
                isDaily: _isDailyMode,
              ),
            );
          }
        }
      } else {
        _resetBoard();
      }

      final newList = List<LetterInfo>.of(_gridInfo);
      _keyboardInfo = {};
      _colorKeyboard(_gridInfo);
      emit(GameState.wordSubmit(board: newList, keyboard: _keyboardInfo));
      return;
    }

    // Level
    _isDailyMode = false;
    _gridInfo = await gameRepository.getLevelBoard(_dictionary) ?? [];
    _currentWordIndex = _gridInfo.length ~/ 5;
    final levelInfo = await gameRepository.getLevelInfo(_dictionary);
    _levelNumber = levelInfo?.lastCompletedLevel ?? 1;
    _isGameComplete = levelInfo?.isGameComplete ?? false;

    if (_isGameComplete) {
      _generateSecretWord(levelNumber: _levelNumber + 1);
      _levelNumber++;
      _resetBoard();
    } else {
      _generateSecretWord(levelNumber: _levelNumber);
    }

    final newList = List<LetterInfo>.of(_gridInfo);
    _keyboardInfo = {};
    _colorKeyboard(_gridInfo);
    emit(GameState.wordSubmit(board: newList, keyboard: _keyboardInfo));
  }

  Future<void> _onShare(
    _ShareEvent event,
    Emitter<GameState> emit,
  ) async {
    final textFunction = event.textFunction;
    final emojiString = _gridInfo.map((e) => e.letterStatus.toEmoji());
    final copiedText = textFunction(_currentWordIndex, emojiString);
    await Clipboard.setData(ClipboardData(text: copiedText));
    await Share.share(copiedText);
  }

  void _onChangeDictionary(
    _ChangeDictionaryEvent event,
    Emitter<GameState> emit,
  ) {
    _dictionary = event.dictionary;
    add(GameEvent.loadGame(isDaily: _isDailyMode, isFirst: false));
  }

  void _resetBoard() {
    _currentWordIndex = 0;
    _isGameComplete = false;
    _gridInfo = [];
  }

  void _generateSecretWord({int levelNumber = 0}) {
    late int index;
    if (levelNumber == 0) {
      final now = DateTime.now();
      final random = Random(now.year * 1000 + now.month * 100 + now.day);
      index = random.nextInt(_dictionary.currentDictionary.length);
    } else {
      index = Random(levelNumber).nextInt(_dictionary.currentDictionary.length);
    }
    _secretWord = _dictionary.currentDictionary.keys.elementAt(index);
    log('Secret: $_secretWord');
  }

  Future<void> _saveStatAndLvl(GameResult gameResult) async {
    if (_isDailyMode) {
      await statisticRepository.saveDailyStatistic(
        isWin: gameResult.isWin!,
        attempt: _currentWordIndex,
        dictionary: _dictionary,
      );
      return;
    }
    await levelsRepository.saveLevels(
      gameResult: gameResult,
      dictionary: _dictionary,
    );
  }

  Future<void> _saveResultAndBoard(GameResult gameResult) async {
    if (_isDailyMode) {
      await gameRepository.saveDailyBoard(_gridInfo, _dictionary);
      await gameRepository.saveDailyResult(gameResult, _dictionary);
      return;
    }
    await gameRepository.saveLevelBoard(_gridInfo, _dictionary);
    await gameRepository.saveLevelInfo(
      LevelInfo(
        lastCompletedLevel: _levelNumber,
        isGameComplete: _isGameComplete,
      ),
      _dictionary,
    );
  }

  void _colorKeyboard(List<LetterInfo> list) {
    bool replaceKeyboardKey(KeyboardKeys? keyboardKey, LetterInfo letter) {
      return _keyboardInfo.containsKey(keyboardKey) &&
          (_keyboardInfo[keyboardKey] == LetterStatus.correctSpot ||
              (_keyboardInfo[keyboardKey] == LetterStatus.wrongSpot &&
                  letter.letterStatus != LetterStatus.correctSpot));
    }

    for (final item in list) {
      final keyboardKey = item.letter.toKeyboardKeys;
      if (keyboardKey == null) {
        continue;
      }
      if (replaceKeyboardKey(keyboardKey, item)) {
        continue;
      }
      _keyboardInfo[keyboardKey] = item.letterStatus;
    }
  }

  List<LetterInfo> get _colorTheWord {
    final updatedList = <LetterInfo>[];
    final word = _buildWord;

    for (var i = 0; i < word.length; i++) {
      final character = word[i];
      var letterStatus = LetterStatus.unknown;
      if (character == _secretWord[i]) {
        letterStatus = LetterStatus.correctSpot;
      } else if (_secretWord.contains(character)) {
        letterStatus = LetterStatus.wrongSpot;
      } else {
        letterStatus = LetterStatus.notInWord;
      }
      updatedList.add(
        LetterInfo(letter: character, letterStatus: letterStatus),
      );
    }

    // Color keyboard info only after 5 last items
    _colorKeyboard(updatedList);

    _currentWordIndex++;
    return updatedList;
  }

  String get _buildWord =>
      _gridInfo[_currentWordIndex * 5].letter +
      _gridInfo[_currentWordIndex * 5 + 1].letter +
      _gridInfo[_currentWordIndex * 5 + 2].letter +
      _gridInfo[_currentWordIndex * 5 + 3].letter +
      _gridInfo[_currentWordIndex * 5 + 4].letter;
}
