import 'package:flutter_test/flutter_test.dart';
import 'package:wordly/src/feature/statistic/data/statistics_repository.dart';
import 'package:wordly/src/feature/statistic/model/game_statistic.dart';

void main() {
  test('win, win, loss, win keeps historical max streak and writes version 2', () {
    var statistic = const GameStatistic(
      wins: 0,
      loses: 0,
      streak: 0,
      maxStreak: 0,
      attempts: GameStatistic.zeroAttempts,
    );
    for (final isWin in [true, true, false, true]) {
      statistic = updatedStatistic(statistic, isWin: isWin, attempt: 1);
    }
    expect(statistic.streak, 1);
    expect(statistic.maxStreak, 2);
    expect(statistic.version, GameStatistic.currentVersion);
  });

  test('never reduces a legacy maxStreak', () {
    const legacy = GameStatistic(version: 1, wins: 10, loses: 2, streak: 0, maxStreak: 8, attempts: [1, 2, 3, 4, 0, 0]);
    final GameStatistic statistic = updatedStatistic(legacy, isWin: true, attempt: 2);
    expect(statistic.maxStreak, 8);
    expect(statistic.version, 2);
  });
}
