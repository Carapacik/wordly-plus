import 'dart:convert' show json;
import 'dart:math' show Random;
import 'dart:ui' show Locale;

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart' show DateFormat;
import 'package:wordly/src/core/constant/generated/assets.gen.dart';
import 'package:wordly/src/feature/game/data/datasources/game_datasource.dart';
import 'package:wordly/src/feature/game/domain/model/game_result.dart';

abstract interface class IGameRepository {
  Future<void> init(Locale dictionary);

  Future<bool> get isFirstEnter;

  GameResult? get savedResult;

  Future<void> setFirstEnter();

  Map<String, String> currentDictionary(Locale dictionary);

  String generateSecretWord(Locale dictionary, {int levelNumber = 0});

  Future<GameResult?> getDaily(Locale dictionary, DateTime date);

  Future<void> setDailyBoard(Locale dictionary, DateTime date, GameResult savedResult);
}

final class GameRepository implements IGameRepository {
  GameRepository({required this._gameDataSource});

  final IGameDatasource _gameDataSource;
  late final Map<String, String> _ruDictionary;
  late final Map<String, String> _enDictionary;
  late final GameResult? _savedResult;

  @override
  Future<void> init(Locale dictionary) async {
    final rawDictionaryRu = await rootBundle.loadString(Assets.dictionary.ru).then(json.decode) as Map<String, dynamic>;
    _ruDictionary = rawDictionaryRu.map((key, value) => MapEntry(key, value.toString()));
    final rawDictionaryEn = await rootBundle.loadString(Assets.dictionary.en).then(json.decode) as Map<String, dynamic>;
    _enDictionary = rawDictionaryEn.map((key, value) => MapEntry(key, value.toString()));
    _savedResult = await getDaily(dictionary, DateTime.now().toUtc());
  }

  @override
  Map<String, String> currentDictionary(Locale dictionary) => switch (dictionary.languageCode) {
    'ru' => _ruDictionary,
    'en' => _enDictionary,
    _ => _enDictionary,
  };

  @override
  String generateSecretWord(Locale dictionary, {int levelNumber = 0}) {
    final Map<String, String> currentDict = currentDictionary(dictionary);
    int index;
    if (levelNumber == 0) {
      final DateTime now = DateTime.now().toUtc();
      final random = Random(now.year * 1000 + now.month * 100 + now.day);
      index = random.nextInt(currentDict.length);
    } else {
      index = Random(levelNumber).nextInt(currentDict.length);
    }
    final String word = currentDict.keys.elementAt(index);
    return word;
  }

  @override
  Future<GameResult?> getDaily(Locale dictionary, DateTime date) =>
      _gameDataSource.getDaily(dictionary.languageCode, DateFormat('dd-MM-yyyy').format(date));

  @override
  Future<void> setDailyBoard(Locale dictionary, DateTime date, GameResult savedResult) =>
      _gameDataSource.setDailyBoard(dictionary.languageCode, DateFormat('dd-MM-yyyy').format(date), savedResult);

  @override
  Future<bool> get isFirstEnter => _gameDataSource.isFirstEnter.then((v) => v ?? true);

  @override
  Future<void> setFirstEnter() => _gameDataSource.setFirstEnter();

  @override
  GameResult? get savedResult => _savedResult;
}
