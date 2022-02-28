import 'package:wordly/data/collections/level_data.dart';
import 'package:wordly/data/models/dictionary_languages.dart';

abstract class LevelRepository {
  LevelData get levelData;

  bool get isLevelMode;

  // ignore: avoid_setters_without_getters
  set levelMode(final bool value);

  Future<void> initLevelData(final DictionaryLanguages dictionaryLanguage);

  Future<void> saveLevelData();
}
