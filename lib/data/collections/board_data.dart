import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:wordly/data/models/dictionary_languages.dart';
import 'package:wordly/data/models/letter_status.dart';

part 'board_data.g.dart';

@Collection()
class BoardData extends Equatable {
  BoardData();

  factory BoardData.init({
    required final DictionaryLanguages language,
    required final int levelNumber,
  }) =>
      BoardData()
        ..isComplete = false
        ..secretWord = ''
        ..levelNumber = levelNumber
        ..language = language
        ..lettersState = ['']
        ..keyboardLetters = []
        ..keyboardLetterStatuses = []
        ..isWin = null;

  @Id()
  int? id;
  late bool isComplete;
  late String secretWord;
  @Index()
  late int levelNumber;
  @Index()
  @DictionaryLanguagesConverter()
  late DictionaryLanguages language;
  late List<String> lettersState;
  late List<String> keyboardLetters;
  late List<int> keyboardLetterStatuses;
  bool? isWin;

  static List<String> toListString(Map<String, LetterStatus> map) =>
      map.entries.map((element) => element.key).toList();

  static List<int> toListLetterStatus(Map<String, LetterStatus> map) =>
      map.entries.map((element) => element.value.index).toList();

  Map<String, LetterStatus> toMap() => {
        for (var i = 0; i < keyboardLetters.length; i++)
          keyboardLetters[i]: LetterStatus.values[keyboardLetterStatuses[i]]
      };

  @override
  List<Object?> get props => [id, levelNumber, language];
}
