import 'dart:convert';
import 'dart:ui' show Locale;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/game/domain/model/game_result.dart';
import 'package:wordly/src/feature/level/data/mappers/game_result_codec.dart';

abstract interface class ILevelDatasource {
  Future<List<GameResult>?> getLevels(String dictionaryKey);

  Future<void> setLevel(String dictionaryKey, GameResult level);

  Future<void> runMigration();
}

final class LevelDatasource implements ILevelDatasource {
  LevelDatasource({required this.sharedPreferences, this.gameResultCodec = const GameResultCodec()});

  final SharedPreferencesAsync sharedPreferences;
  final GameResultCodec gameResultCodec;

  SharedPreferencesColumnJson sharedPreferencesColumnJson(String dictionaryKey) =>
      SharedPreferencesColumnJson(sharedPreferences: sharedPreferences, key: _levelsKey(dictionaryKey));

  String _levelsKey(String dictionaryKey) => 'level.$dictionaryKey';

  @override
  Future<List<GameResult>?> getLevels(String dictionaryKey) async {
    final Map<String, Object?>? settingsMap = await sharedPreferencesColumnJson(dictionaryKey).read();
    if (settingsMap == null) {
      return null;
    }
    try {
      final Object? rawLevels = settingsMap['levels'];
      if (rawLevels is! List) {
        throw const FormatException('Stored levels are not a list');
      }
      return rawLevels
          .map((rawLevel) {
            if (rawLevel is! Map) {
              throw const FormatException('Stored level is not a JSON object');
            }
            return gameResultCodec.decode(Map<String, Object?>.from(rawLevel));
          })
          .toList(growable: false);
    } on Object {
      return null;
    }
  }

  @override
  Future<void> setLevel(String dictionaryKey, GameResult level) async {
    final List<GameResult> previousLevels = (await getLevels(dictionaryKey) ?? [])..add(level);
    final List<Map<String, Object?>> rawLevels = previousLevels.map(gameResultCodec.encode).toList(growable: false);
    await sharedPreferencesColumnJson(dictionaryKey).set(<String, Object?>{'levels': rawLevels});
  }

  @override
  Future<void> runMigration() async {
    const dictionaries = [Locale('en'), Locale('ru')];
    for (final dictionary in dictionaries) {
      try {
        final List<String>? levels = await sharedPreferences.getStringList(_levelsKey(dictionary.languageCode));
        if (levels == null || levels.isEmpty) {
          continue;
        }
        final decodedLevels = <GameResult>[];
        for (var index = 0; index < levels.length; index++) {
          final Object? decoded = jsonDecode(levels[index]);
          if (decoded is! Map) {
            continue;
          }
          final decodedMap = Map<String, Object?>.from(decoded);
          if (decodedMap.containsKey('word') || decodedMap.containsKey('isWin')) {
            decodedLevels.add(
              GameResult(
                secretWord: decodedMap['word'].toString(),
                isWin: decodedMap['isWin'] as bool?,
                lvlNumber: index + 1,
              ),
            );
          } else if (decodedMap.containsKey('secretWord')) {
            decodedLevels.add(gameResultCodec.decode(decodedMap));
          }
        }
        if (decodedLevels.isEmpty) {
          continue;
        }
        await sharedPreferencesColumnJson(
          dictionary.languageCode,
        ).set(<String, Object?>{'levels': decodedLevels.map(gameResultCodec.encode).toList(growable: false)});
      } on Object {
        // nothing
      }
    }
  }
}
