import 'dart:convert';

import 'package:wordle/data/models/game_statistic.dart';
import 'package:wordle/data/repositories/save_reactive_repository.dart';
import 'package:wordle/data/shared_preferences_data.dart';

class GameStatisticRepository extends SaveReactiveRepository<GameStatistic> {
  factory GameStatisticRepository.getInstance() => _instance ??=
      GameStatisticRepository._internal(SharedPreferenceData.getInstance());

  GameStatisticRepository._internal(this.spData);

  static GameStatisticRepository? _instance;

  final SharedPreferenceData spData;

  @override
  GameStatistic convertFromString(String rawItem) =>
      GameStatistic.fromJson(json.decode(rawItem) as Map<String, dynamic>);

  @override
  String convertToString(GameStatistic item) => json.encode(item.toJson());

  @override
  Future<String?> getRawData() => spData.getGameStatistic();

  @override
  Future<bool> setRawData(String item) => spData.saveGameStatistic(item);
}
