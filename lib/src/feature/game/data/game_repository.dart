import 'dart:ui' show Locale;

import 'package:intl/intl.dart' show DateFormat;
import 'package:wordly/src/feature/game/data/dictionary/dictionary_database.dart';
import 'package:wordly/src/feature/game/data/dictionary/word_schedule.dart';
import 'package:wordly/src/feature/game/data/game_datasource.dart';
import 'package:wordly/src/feature/game/model/game_result.dart';
import 'package:wordly/src/logging/app_logger.dart';

abstract interface class IGameRepository() {
  Future<void> init(Locale dictionary);

  Future<bool> get isFirstEnter;

  GameResult? get savedResult;

  Future<void> setFirstEnter();

  bool containsWord(Locale dictionary, String word);

  Future<String> definition(Locale dictionary, String word);

  String generateSecretWord(Locale dictionary, {int levelNumber = 0, DateTime? date});

  Future<GameResult?> getDaily(Locale dictionary, DateTime date);

  Future<void> setDailyBoard(Locale dictionary, DateTime date, GameResult savedResult);
}

final class GameRepository({
  required final IGameDatasource _gameDataSource,
  required final DictionaryDatabase _ruDatabase,
  required final DictionaryDatabase _enDatabase,
  final DateTime Function() clock = DateTime.now,
}) implements IGameRepository {
  late final Set<String> _ruSet;
  late final Set<String> _enSet;
  late final WordSchedule _ruSchedule;
  late final WordSchedule _enSchedule;
  late final GameResult? _savedResult;

  @override
  Future<void> init(Locale dictionary) async {
    _ruSet = (await _ruDatabase.words()).toSet();
    _enSet = (await _enDatabase.words()).toSet();
    _ruSchedule = await _ruDatabase.schedule();
    _enSchedule = await _enDatabase.schedule();
    _savedResult = await getDaily(dictionary, clock().toUtc());
  }

  @override
  bool containsWord(Locale dictionary, String word) =>
      (dictionary.languageCode == 'ru' ? _ruSet : _enSet).contains(word);

  @override
  Future<String> definition(Locale dictionary, String word) async {
    try {
      return await (dictionary.languageCode == 'ru' ? _ruDatabase : _enDatabase).definition(word) ?? '';
    } on Exception catch (error, stackTrace) {
      // A failed optional definition must not hide a completed game's result.
      AppLogger.warning('Could not load dictionary definition', error: error, stackTrace: stackTrace);
      return '';
    }
  }

  Future<void> close() async {
    await _ruDatabase.close();
    await _enDatabase.close();
  }

  @override
  String generateSecretWord(Locale dictionary, {int levelNumber = 0, DateTime? date}) {
    final WordSchedule schedule = dictionary.languageCode == 'ru' ? _ruSchedule : _enSchedule;
    return levelNumber == 0 ? schedule.daily(date ?? clock()) : schedule.level(levelNumber);
  }

  @override
  Future<GameResult?> getDaily(Locale dictionary, DateTime date) =>
      _gameDataSource.getDaily(dictionary.languageCode, DateFormat('dd-MM-yyyy').format(date.toUtc()));

  @override
  Future<void> setDailyBoard(Locale dictionary, DateTime date, GameResult savedResult) => _gameDataSource.setDailyBoard(
    dictionary.languageCode,
    DateFormat('dd-MM-yyyy').format(date.toUtc()),
    savedResult,
  );

  @override
  Future<bool> get isFirstEnter => _gameDataSource.isFirstEnter.then((v) => v ?? true);

  @override
  Future<void> setFirstEnter() => _gameDataSource.setFirstEnter();

  @override
  GameResult? get savedResult => _savedResult;
}
