import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/statistic/data/mappers/statistic_codec.dart';
import 'package:wordly/src/feature/statistic/domain/model/game_statistic.dart';

abstract interface class IStatisticDatasource() {
  Future<GameStatistic> read(String dictionary);

  Future<void> save(String dictionary, GameStatistic statistic);
}

final class StatisticDatasource({
  required final SharedPreferencesAsync sharedPreferences,
  final StatisticCodec statisticCodec = const StatisticCodec(),
}) implements IStatisticDatasource {
  SharedPreferencesColumnJson sharedPreferencesColumnJson(String dictionaryKey) =>
      SharedPreferencesColumnJson(sharedPreferences: sharedPreferences, key: 'statistic.$dictionaryKey');

  @override
  Future<void> save(String dictionary, GameStatistic statistic) async {
    final Map<String, Object?> s = statisticCodec.encode(statistic);

    await sharedPreferencesColumnJson(dictionary).set(s);
  }

  @override
  Future<GameStatistic> read(String dictionary) async {
    final Map<String, Object?>? settingsMap = await sharedPreferencesColumnJson(dictionary).read();
    if (settingsMap == null) {
      return const GameStatistic(wins: 0, loses: 0, streak: 0, maxStreak: 0, attempts: GameStatistic.zeroAttempts);
    }
    try {
      return statisticCodec.decode(settingsMap);
    } on Object {
      return const GameStatistic(wins: 0, loses: 0, streak: 0, maxStreak: 0, attempts: GameStatistic.zeroAttempts);
    }
  }
}
