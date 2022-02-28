import 'dart:convert';

import 'package:auth_repository/auth_repository.dart';
import 'package:wordle/data/repositories/save_reactive_repository.dart';
import 'package:wordle/data/shared_preferences_data.dart';

class StatisticRepository extends SaveReactiveRepository<Statistic> {
  factory StatisticRepository.getInstance() => _instance ??=
      StatisticRepository._internal(SharedPreferenceData.getInstance());

  StatisticRepository._internal(this.spData);

  static StatisticRepository? _instance;

  final SharedPreferenceData spData;

  @override
  Statistic convertFromString(String rawItem) =>
      Statistic.fromJson(json.decode(rawItem) as Map<String, dynamic>);

  @override
  String convertToString(Statistic item) => json.encode(item.toJson());

  @override
  Future<String?> getRawData() => spData.getStatistic();

  @override
  Future<bool> setRawData(String item) => spData.saveStatistic(item);
}
