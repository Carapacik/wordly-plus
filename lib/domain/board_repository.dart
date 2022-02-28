import 'package:wordly/data/collections/board_data.dart';
import 'package:wordly/data/models/dictionary_languages.dart';

abstract class BoardRepository {
  BoardData get boardData;

  Future<void> initBoardData({
    required final DictionaryLanguages dictionaryLanguage,
    required final int levelNumber,
  });

  Future<void> saveBoardData(final BoardData data);

  Future<List<BoardData>> getAllData();

  Future<bool> isFirstLaunch();
}
