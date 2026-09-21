import 'dart:async';
import 'dart:math' show max;

import 'package:wordly/src/feature/statistic/data/statistic_datasource.dart';
import 'package:wordly/src/feature/statistic/model/game_statistic.dart';

abstract interface class IStatisticsRepository() {
  Future<GameStatistic?> getStatistic(String dictionary);
}

final class const StatisticsRepository({required final IStatisticDatasource _statisticsDatasource})
    implements IStatisticsRepository {
  @override
  Future<GameStatistic?> getStatistic(String dictionary) => _statisticsDatasource.read(dictionary);
}

GameStatistic updatedStatistic(GameStatistic previous, {required bool isWin, required int attempt}) {
  if (attempt < 1 || attempt > 6) {
    throw RangeError.range(attempt, 1, 6, 'attempt');
  }
  final int streak = isWin ? previous.streak + 1 : 0;
  final attempts = List<int>.of(previous.attempts);
  if (isWin) {
    attempts[attempt - 1]++;
  }
  return GameStatistic(
    wins: previous.wins + (isWin ? 1 : 0),
    loses: previous.loses + (isWin ? 0 : 1),
    streak: streak,
    maxStreak: max(previous.maxStreak, streak),
    attempts: attempts,
  );
}
