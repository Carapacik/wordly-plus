import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordly/data/models.dart';

abstract class ISaveStatisticRepository {
  Future<StatisticInfo?> getDailyStatistic(DictionaryEnum dictionary);

  Future<void> saveDailyStatistic({
    required bool isWin,
    required int attempt,
    required DictionaryEnum dictionary,
  });
}

class SaveStatisticRepository implements ISaveStatisticRepository {
  static const _statisticKey = 'statistic_';

  @override
  Future<StatisticInfo?> getDailyStatistic(DictionaryEnum dictionary) async {
    final sp = await SharedPreferences.getInstance();
    final rawInfo = sp.getString(_statisticKey + dictionary.key);
    if (rawInfo == null) {
      return null;
    }
    return StatisticInfo.fromJson(json.decode(rawInfo) as Map<String, dynamic>);
  }

  @override
  Future<void> saveDailyStatistic({
    required bool isWin,
    required int attempt,
    required DictionaryEnum dictionary,
  }) async {
    final sp = await SharedPreferences.getInstance();
    final previousStatistic = await getDailyStatistic(dictionary);
    final currentStatistic = StatisticInfo(
      loses: _calculateLoses(isWin: isWin, previous: previousStatistic?.loses),
      wins: _calculateWins(isWin: isWin, previous: previousStatistic?.wins),
      streak:
          _calculateStreak(isWin: isWin, previous: previousStatistic?.streak),
      maxStreak: _calculateMaxStreak(
        isWin: isWin,
        previous: previousStatistic?.maxStreak,
      ),
      attempts: _calculateAttempts(
        attempt: isWin ? attempt - 1 : -1,
        previous: previousStatistic?.attempts,
      ),
    );
    final rawInfo = json.encode(currentStatistic.toJson());
    await sp.setString(_statisticKey + dictionary.key, rawInfo);
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

  int _calculateMaxStreak({required bool isWin, required int? previous}) {
    if (!isWin) {
      return previous ?? 0;
    }
    if (previous == null) {
      return 1;
    }
    return previous + 1;
  }

  List<int> _calculateAttempts({
    required int attempt,
    required List<int>? previous,
  }) {
    if (attempt == -1) {
      return previous ?? StatisticInfo.zeroAttempts;
    }
    if (previous == null) {
      final currentAttempts = List<int>.of(StatisticInfo.zeroAttempts);
      currentAttempts[attempt] += 1;
      return currentAttempts;
    }
    final currentAttempts = List<int>.of(previous);
    currentAttempts[attempt] += 1;
    return currentAttempts;
  }
}
