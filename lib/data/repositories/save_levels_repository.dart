import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordly/data/models.dart';

abstract class ISaveLevelsRepository {
  Future<List<GameResult>?> getLevels(DictionaryEnum dictionary);

  Future<void> saveLevels({
    required GameResult gameResult,
    required DictionaryEnum dictionary,
  });
}

class SaveLevelsRepository implements ISaveLevelsRepository {
  static const _levelKey = 'level_';

  @override
  Future<List<GameResult>?> getLevels(DictionaryEnum dictionary) async {
    final sp = await SharedPreferences.getInstance();
    final rawList = sp.getStringList(_levelKey + dictionary.key);
    return rawList
        ?.map(
          (item) =>
              GameResult.fromJson(json.decode(item) as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<void> saveLevels({
    required GameResult gameResult,
    required DictionaryEnum dictionary,
  }) async {
    final sp = await SharedPreferences.getInstance();
    final previousLevels = (await getLevels(dictionary) ?? [])..add(gameResult);
    final rawLevels =
        previousLevels.map((rawItem) => json.encode(rawItem.toJson())).toList();
    await sp.setStringList(_levelKey + dictionary.key, rawLevels);
  }
}
