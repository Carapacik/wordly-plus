import 'dart:async';
import 'dart:math' show max;

import 'package:wordly/src/feature/statistic/data/datasources/statistic_datasource.dart';
import 'package:wordly/src/feature/statistic/domain/model/game_statistic.dart';

abstract interface class IStatisticsRepository {
  Future<GameStatistic?> getStatistic(String dictionary);

  Future<void> saveStatistic(String dictionary, {required bool isWin, required int attempt});
}

final class StatisticsRepository implements IStatisticsRepository {
  const StatisticsRepository({required this._statisticsDatasource});

  final IStatisticDatasource _statisticsDatasource;

  @override
  Future<GameStatistic?> getStatistic(String dictionary) async => _statisticsDatasource.read(dictionary);

  @override
  Future<void> saveStatistic(String dictionary, {required bool isWin, required int attempt}) async {
    final GameStatistic previousStatistic = await _statisticsDatasource.read(dictionary);
    final int newStreak = _calculateStreak(isWin: isWin, previous: previousStatistic.streak);
    final currentStatistic = GameStatistic(
      loses: _calculateLoses(isWin: isWin, previous: previousStatistic.loses),
      wins: _calculateWins(isWin: isWin, previous: previousStatistic.wins),
      streak: newStreak,
      maxStreak: max(previousStatistic.maxStreak, newStreak),
      attempts: _calculateAttempts(attempt: isWin ? attempt - 1 : -1, previous: previousStatistic.attempts),
    );
    await _statisticsDatasource.save(dictionary, currentStatistic);
  }

  int _calculateLoses({required bool isWin, required int? previous}) {
    if (isWin) {
      return previous ?? 0;
    }
    if (previous == null) {
      return 1;
    }
    return previous + 1;
  }

  int _calculateWins({required bool isWin, required int? previous}) {
    if (!isWin) {
      return previous ?? 0;
    }
    if (previous == null) {
      return 1;
    }
    return previous + 1;
  }

  int _calculateStreak({required bool isWin, required int? previous}) {
    if (!isWin) {
      return 0;
    }
    if (previous == null) {
      return 1;
    }
    return previous + 1;
  }

  List<int> _calculateAttempts({required int attempt, required List<int>? previous}) {
    if (attempt == -1) {
      return previous ?? GameStatistic.zeroAttempts;
    }
    if (previous == null) {
      final currentAttempts = List<int>.of(GameStatistic.zeroAttempts);
      currentAttempts[attempt] += 1;
      return currentAttempts;
    }
    final currentAttempts = List<int>.of(previous);
    currentAttempts[attempt] += 1;
    return currentAttempts;
  }
}
