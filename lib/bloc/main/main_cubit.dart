import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:wordly/data/models/dictionary_languages.dart';
import 'package:wordly/data/models/flushbar_types.dart';
import 'package:wordly/data/models/keyboard_keys.dart';
import 'package:wordly/data/models/letter_status.dart';
import 'package:wordly/data/repositories/dictionary_repository.dart';
import 'package:wordly/domain/board_repository.dart';
import 'package:wordly/domain/daily_result_repository.dart';
import 'package:wordly/domain/daily_statistic_repository.dart';
import 'package:wordly/domain/level_repository.dart';
import 'package:wordly/domain/settings_repository.dart';
import 'package:wordly/utils/utils.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit(this.dictionaryRepository) : super(MainInitial());
  final DictionaryRepository dictionaryRepository;

  void keyDown(final RawKeyDownEvent event, final DictionaryLanguages lang) {
    if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
      final wordComplete = completeWord();
      if (wordComplete) {
        dictionaryRepository.getAllLettersInList().map(
          (index, value) {
            final key = KeyboardKeys.values.firstWhere(
              (element) => element.fromDictionaryLang(lang) == value,
            );
            if (dictionaryRepository.secretWord[index] == value) {
              updateKey(key, LetterStatus.correctSpot);
              return MapEntry(index, value);
            }
            if (dictionaryRepository.secretWord.contains(value)) {
              updateKey(key, LetterStatus.wrongSpot);
              return MapEntry(index, value);
            }
            updateKey(key, LetterStatus.notInWords);
            return MapEntry(index, value);
          },
        );
      }
      return;
    }

    if (event.isKeyPressed(LogicalKeyboardKey.delete) ||
        event.isKeyPressed(LogicalKeyboardKey.backspace)) {
      removeLetter();
      return;
    }
    final key = KeyboardKeys.fromLogicalKey(event.logicalKey);
    if (key != null) {
      setLetter(key);
      return;
    }
  }

  void setLetter(final KeyboardKeys keyboardKey) {
    if (dictionaryRepository.setLetter(keyboardKey)) {
      emit(GridUpdateState());
    }
  }

  void removeLetter() {
    dictionaryRepository.removeLetter();
    emit(GridUpdateState());
  }

  void removeFullWord() {
    dictionaryRepository.removeFullWord();
    emit(GridUpdateState());
  }

  void updateKey(final KeyboardKeys key, final LetterStatus letterStatus) {
    emit(KeyboardKeyUpdateState(key, letterStatus));
  }

  bool completeWord() {
    final levelRepository = GetIt.I<LevelRepository>();
    final settingsRepository = GetIt.I<SettingsRepository>();
    final dailyResultRepository = GetIt.I<DailyResultRepository>();
    final dailyStatisticRepository = GetIt.I<DailyStatisticRepository>();
    final state = dictionaryRepository.completeWord();
    if (state == null) {
      return false;
    }
    if (state is GridUpdateState ||
        state is WinGameState ||
        state is LoseGameState) {
      bool? isWin;
      if (state is WinGameState) {
        isWin = true;
      } else if (state is LoseGameState) {
        isWin = false;
      }
      dictionaryRepository.saveBoard(isWin: isWin);
      emit(state);
      if (state is WinGameState || state is LoseGameState) {
        if (levelRepository.isLevelMode) {
          levelRepository.saveLevelData();
          appearReview();
        } else {
          final dictionaryLanguage =
              settingsRepository.settingsData.dictionaryLanguage;
          dailyResultRepository.saveDailyResult(
            isWin: state is WinGameState,
            word: dictionaryRepository.secretWord,
            language: dictionaryLanguage,
          );
          dailyStatisticRepository.saveStatisticData(
            isWin: state is WinGameState,
            attempt: dictionaryRepository.currentAttempt,
          );
        }
        emit(GridUpdateState());
      }
      return true;
    } else if (state is TopMessageState) {
      emit(state);
    }
    return false;
  }

  Future<void> loadDaily() async {
    final settingsRepository = GetIt.I<SettingsRepository>();
    final boardRepository = GetIt.I<BoardRepository>();
    GetIt.I<LevelRepository>().levelMode = false;

    final dictionaryLanguage =
        settingsRepository.settingsData.dictionaryLanguage;
    dictionaryRepository
      ..resetData()
      ..createSecretWord();
    await boardRepository.initBoardData(
      dictionaryLanguage: dictionaryLanguage,
      levelNumber: 0,
    );
    dictionaryRepository.loadBoard();
    emit(GridUpdateState());
  }

  Future<void> loadLevels() async {
    final settingsRepository = GetIt.I<SettingsRepository>();
    final boardRepository = GetIt.I<BoardRepository>();
    final levelRepository = GetIt.I<LevelRepository>()..levelMode = true;
    final dictionaryLanguage =
        settingsRepository.settingsData.dictionaryLanguage;
    await levelRepository.initLevelData(dictionaryLanguage);
    final levelNumber = levelRepository.levelData.lastLevel;
    dictionaryRepository
      ..resetData()
      ..createSecretWord(levelNumber);
    await boardRepository.initBoardData(
      dictionaryLanguage: dictionaryLanguage,
      levelNumber: levelNumber,
    );
    dictionaryRepository.loadBoard();
    emit(GridUpdateState());
  }

  void clearGameArea([int levelNumber = 0]) {
    dictionaryRepository
      ..resetData()
      ..createSecretWord(levelNumber);
    emit(MainInitial());
  }
}
