import 'package:wordly/bloc/main/main_cubit.dart';
import 'package:wordly/data/models/dictionary_languages.dart';
import 'package:wordly/data/models/keyboard_keys.dart';
import 'package:wordly/data/models/letter_info.dart';
import 'package:wordly/data/models/letter_status.dart';

abstract class DictionaryRepository {
  // ignore: avoid_setters_without_getters
  set dictionaryLanguage(DictionaryLanguages language);

  String get secretWord;

  String get secretWordMeaning;

  int get currentAttempt;

  String get getEmojiString;

  void createSecretWord([int level = 0]);

  List<LetterInfo> letterStatusesForGrid();

  bool setLetter(final KeyboardKeys key);

  void removeLetter();

  void removeFullWord();

  void resetData();

  MainState? completeWord();

  LetterStatus getKeyStatus(String? keyName);

  Map<int, String> getAllLettersInList();

  void loadBoard();

  void saveBoard({bool? isWin});
}
