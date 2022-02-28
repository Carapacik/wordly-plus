import 'dart:math';

import 'package:get_it/get_it.dart';
import 'package:wordly/bloc/main/main_cubit.dart';
import 'package:wordly/data/collections/board_data.dart';
import 'package:wordly/data/models/dictionary_languages.dart';
import 'package:wordly/data/models/flushbar_types.dart';
import 'package:wordly/data/models/indexed_letter_info.dart';
import 'package:wordly/data/models/keyboard_keys.dart';
import 'package:wordly/data/models/letter_info.dart';
import 'package:wordly/data/models/letter_status.dart';
import 'package:wordly/data/repositories/dictionary_repository.dart';
import 'package:wordly/domain/board_repository.dart';
import 'package:wordly/domain/level_repository.dart';

class DictionaryRepositoryImpl implements DictionaryRepository {
  late DictionaryLanguages _dictionaryLanguage;
  int _currentWordIndex = 0;
  bool _completeGame = false;
  String? _secretWord;
  Map<String, LetterStatus> _keyboardState = {};
  final Map<String, int> _secretLettersMap = {};
  List<String> _gridData = [''];
  List<LetterInfo> _emojiList = [];

  @override
  String get secretWord => _secretWord ?? '';

  @override
  String get secretWordMeaning =>
      _dictionaryLanguage.currentDictionary[_secretWord] ?? '';

  @override
  int get currentAttempt => _currentWordIndex;

  @override
  // ignore: avoid_setters_without_getters
  set dictionaryLanguage(DictionaryLanguages dictionaryLanguage) =>
      _dictionaryLanguage = dictionaryLanguage;

  @override
  MainState? completeWord() {
    if (_completeGame) {
      return null;
    }
    if (_gridData.length <= _currentWordIndex) {
      _gridData.add('');
    }
    if (_currentWordIndex < 6) {
      if (_gridData[_currentWordIndex].length == 5) {
        if (_gridData[_currentWordIndex] == _secretWord) {
          _checkWord();
          _completeGame = true;
          return WinGameState();
        }
        if (_currentWordIndex == 5 &&
            _dictionaryLanguage.currentDictionary
                .containsKey(_gridData[_currentWordIndex])) {
          _checkWord();
          _completeGame = true;
          return LoseGameState();
        }
        if (_dictionaryLanguage.currentDictionary
            .containsKey(_gridData[_currentWordIndex])) {
          _checkWord();
          return GridUpdateState();
        }
        return TopMessageState(SnackbarType.notFound);
      }
      return TopMessageState(SnackbarType.notCorrectLength);
    }
    return null;
  }

  void _checkWord() {
    if (_secretWord == null) {
      return;
    }
    final word = _gridData[_currentWordIndex];
    word.split('').asMap().map((key, value) {
      var currentStatus = LetterStatus.unknown;
      if (_secretWord![key] == value) {
        // LetterStatus.correctSpot
        if (_keyboardState.containsKey(value)) {
          _keyboardState.update(value, (value) => LetterStatus.correctSpot);
        } else {
          _keyboardState.addAll({value: LetterStatus.correctSpot});
        }
        currentStatus = LetterStatus.correctSpot;
      } else if (_secretWord!.contains(value)) {
        // LetterStatus.wrongSpot
        if (_keyboardState.containsKey(value)) {
          if (_keyboardState[key] == LetterStatus.notInWords) {
            _keyboardState.update(value, (value) => LetterStatus.wrongSpot);
          }
        } else {
          _keyboardState.addAll({value: LetterStatus.wrongSpot});
        }
        currentStatus = LetterStatus.wrongSpot;
      } else {
        // LetterStatus.notInWords
        if (!_keyboardState.containsKey(value)) {
          _keyboardState.addAll({value: LetterStatus.notInWords});
        }
        currentStatus = LetterStatus.notInWords;
      }
      _emojiList.add(
        LetterInfo(letter: value, letterStatus: currentStatus),
      );

      return MapEntry(key, value);
    });
    if (_currentWordIndex < 6) {
      _currentWordIndex++;
    }
  }

  @override
  void createSecretWord([int level = 0]) {
    final dictionary = _dictionaryLanguage.currentDictionary;
    late int index;
    if (level == 0) {
      final now = DateTime.now();
      final random = Random(now.year * 10000 + now.month * 100 + now.day);
      index = random.nextInt(dictionary.length);
    } else {
      index = Random(level).nextInt(dictionary.length);
    }
    _secretWord = dictionary.keys.elementAt(index);

    final listSecretWord = _secretWord!.split('');
    for (final letter in listSecretWord) {
      if (!_secretLettersMap.containsKey(letter)) {
        _secretLettersMap[letter] =
            listSecretWord.where((element) => element == letter).length;
      }
    }
  }

  @override
  bool setLetter(final KeyboardKeys key) {
    if (_completeGame) {
      return false;
    }
    if (KeyboardKeys.enter.fromDictionaryLang == key.fromDictionaryLang) {
      return false;
    }
    if (_gridData.length <= _currentWordIndex) {
      _gridData.add('');
    }
    if (_gridData[_currentWordIndex].length < 5) {
      _gridData[_currentWordIndex] = _gridData[_currentWordIndex] +
          (key.fromDictionaryLang(_dictionaryLanguage) ?? '');
      return true;
    }
    return false;
  }

  @override
  void removeLetter() {
    if (_gridData.length <= _currentWordIndex) {
      _gridData.add('');
    }
    final wordLength = _gridData[_currentWordIndex].length;
    if (wordLength > 0) {
      _gridData[_currentWordIndex] =
          _gridData[_currentWordIndex].substring(0, wordLength - 1);
    }
  }

  @override
  void removeFullWord() {
    if (_gridData.length <= _currentWordIndex) {
      _gridData.add('');
    }
    final wordLength = _gridData[_currentWordIndex].length;
    if (wordLength > 0) {
      _gridData[_currentWordIndex] = '';
    }
  }

  @override
  List<LetterInfo> letterStatusesForGrid() {
    final letterStatusesList = <LetterInfo>[];
    for (var i = 0; i < _gridData.length; i++) {
      final word = _gridData[i];
      final tempList = <LetterInfo>[];
      if (word.length < 5 || _currentWordIndex == i) {
        for (final letter in word.split('')) {
          tempList.add(
            LetterInfo(
              letter: letter,
              letterStatus: LetterStatus.unknown,
            ),
          );
        }
        tempList.addAll(
          List.generate(
            5 - word.length,
            (index) => const LetterInfo(
              letter: '',
              letterStatus: LetterStatus.unknown,
            ),
          ),
        );
      } else {
        for (var i = 0; i < word.length; i++) {
          if (_secretWord?[i] == word[i]) {
            tempList.add(
              LetterInfo(
                letter: word[i],
                letterStatus: LetterStatus.correctSpot,
              ),
            );
          } else if (_secretWord?.contains(word[i]) ?? false) {
            tempList.add(
              LetterInfo(
                letter: word[i],
                letterStatus: LetterStatus.wrongSpot,
              ),
            );
          } else {
            tempList.add(
              LetterInfo(
                letter: word[i],
                letterStatus: LetterStatus.notInWords,
              ),
            );
          }
        }

        // To change colors for duplicate letters
        final greenList = <IndexedLetterInfo>[];
        final yellowList = <IndexedLetterInfo>[];
        tempList.asMap().map((index, letter) {
          if (letter.letterStatus == LetterStatus.correctSpot) {
            greenList.add(IndexedLetterInfo(indexInWord: index, info: letter));
          } else if (letter.letterStatus == LetterStatus.wrongSpot) {
            yellowList.add(IndexedLetterInfo(indexInWord: index, info: letter));
          }
          return MapEntry(index, letter);
        });

        if (yellowList.isNotEmpty) {
          for (final yellow in yellowList) {
            final countInGreenList = greenList
                .where((element) => yellow.info.letter == element.info.letter)
                .length;
            if (countInGreenList > 0) {
              final countInSecretWord = _secretLettersMap[yellow.info.letter];
              if (countInSecretWord == countInGreenList) {
                yellowList
                    .where(
                  (element) => element.info.letter == yellow.info.letter,
                )
                    .forEach((e) {
                  tempList[e.indexInWord] = LetterInfo(
                    letter: e.info.letter,
                    letterStatus: LetterStatus.notInWords,
                  );
                });
              }
            }
          }
        }
      }
      letterStatusesList.addAll(tempList);
    }
    if (letterStatusesList.length < 30) {
      letterStatusesList.addAll(
        List.generate(
          30 - letterStatusesList.length,
          (index) => const LetterInfo(
            letter: '',
            letterStatus: LetterStatus.unknown,
          ),
        ),
      );
    }
    return letterStatusesList;
  }

  @override
  LetterStatus getKeyStatus(String? keyName) =>
      _keyboardState[keyName] ?? LetterStatus.unknown;

  @override
  Map<int, String> getAllLettersInList() =>
      _gridData[_currentWordIndex - 1].split('').asMap();

  @override
  void loadBoard() {
    final boardData = GetIt.I<BoardRepository>().boardData;
    if (boardData.id != null && boardData.secretWord == _secretWord) {
      _keyboardState = boardData.toMap();
      _completeGame = boardData.isComplete;
      _currentWordIndex = boardData.lettersState.length;
      _gridData = boardData.lettersState;
      _keyboardState = boardData.toMap();
      // after created _secretWord and filled _gridData
      _emojiList = letterStatusesForGrid();
    }
  }

  @override
  void saveBoard({bool? isWin}) {
    final levelRepository = GetIt.I<LevelRepository>();
    final boardData = BoardData()
      ..language = _dictionaryLanguage
      ..levelNumber =
          levelRepository.isLevelMode ? levelRepository.levelData.lastLevel : 0
      ..secretWord = _secretWord ?? ''
      ..isComplete = _completeGame
      ..keyboardLetters = BoardData.toListString(_keyboardState)
      ..keyboardLetterStatuses = BoardData.toListLetterStatus(_keyboardState)
      ..lettersState = _gridData
      ..isWin = isWin;
    GetIt.I<BoardRepository>().saveBoardData(boardData);
  }

  @override
  String get getEmojiString {
    var emojiString = '';
    _emojiList.asMap().map((key, value) {
      emojiString += value.letterStatus.toEmoji();
      if (key % 5 == 4) {
        emojiString += '\n';
      }
      return MapEntry(key, value);
    });
    return emojiString;
  }

  @override
  void resetData() {
    _secretWord = null;
    _completeGame = false;
    _gridData = [''];
    _keyboardState = {};
    _currentWordIndex = 0;
    _emojiList.clear();
  }
}
