import 'package:flutter_test/flutter_test.dart';
import 'package:wordly/src/feature/statistic/data/datasources/statistic_datasource.dart';
import 'package:wordly/src/feature/statistic/domain/model/game_statistic.dart';
import 'package:wordly/src/feature/statistic/domain/repositories/statistics_repository.dart';

void main() {
  test('win, win, loss, win keeps historical max streak and writes version 2', () async {
    final datasource = _MemoryStatisticDatasource();
    final repository = StatisticsRepository(statisticsDatasource: datasource);

    for (final isWin in [true, true, false, true]) {
      await repository.saveStatistic('en', isWin: isWin, attempt: 1);
    }

    expect(datasource.value.streak, 1);
    expect(datasource.value.maxStreak, 2);
    expect(datasource.value.version, GameStatistic.currentVersion);
  });

  test('never reduces a legacy maxStreak', () async {
    final datasource = _MemoryStatisticDatasource(
      const GameStatistic(version: 1, wins: 10, loses: 2, streak: 0, maxStreak: 8, attempts: [1, 2, 3, 4, 0, 0]),
    );
    final repository = StatisticsRepository(statisticsDatasource: datasource);

    await repository.saveStatistic('en', isWin: true, attempt: 2);

    expect(datasource.value.maxStreak, 8);
    expect(datasource.value.version, 2);
  });
}

final class _MemoryStatisticDatasource([
  var GameStatistic value = const GameStatistic(
    wins: 0,
    loses: 0,
    streak: 0,
    maxStreak: 0,
    attempts: GameStatistic.zeroAttempts,
  ),
]) implements IStatisticDatasource {
  @override
  Future<GameStatistic> read(String dictionary) async => value;

  @override
  Future<void> save(String dictionary, GameStatistic statistic) async => value = statistic;
}
