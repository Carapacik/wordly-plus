import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordly/src/feature/statistic/data/statistic_codec.dart';
import 'package:wordly/src/feature/statistic/model/game_statistic.dart';
import 'package:wordly/src/storage/shared_preferences_column.dart';

abstract interface class IStatisticDatasource() {
  Future<GameStatistic> read(String dictionary);
}

final class LegacyStatisticDatasource({
  required final SharedPreferencesAsync sharedPreferences,
  final StatisticCodec statisticCodec = const StatisticCodec(),
}) implements IStatisticDatasource {
  SharedPreferencesColumnJson _column(String dictionaryKey) =>
      SharedPreferencesColumnJson(sharedPreferences: sharedPreferences, key: 'statistic.$dictionaryKey');

  @override
  Future<GameStatistic> read(String dictionary) async {
    final Map<String, Object?>? settingsMap = await _column(dictionary).read();
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
