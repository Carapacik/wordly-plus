import 'package:auth_repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wordle/data/dictionary_data.dart';
import 'package:wordle/data/models/daily_result.dart';
import 'package:wordle/data/models/game_statistic.dart';
import 'package:wordle/data/repositories/daily_result_repository.dart';
import 'package:wordle/data/repositories/game_statistic_repository.dart';
import 'package:wordle/data/repositories/statistic_repository.dart';
import 'package:wordle/presentation/widgets/dialogs/win_lose.dart';

export 'duration.dart';
export 'firebase.dart';
export 'locale.dart';
export 'share_copy.dart';

Future<void> showDialogIfNeed(
  final BuildContext context, {
  final bool? isWin,
}) async {
  final savedStatistic =
      await GameStatisticRepository.getInstance().getItem() ??
          const GameStatistic();
  if (isWin != null) {
    final secretWord = DictionaryData.getInstance().secretWord;
    DailyResultRepository.getInstance().setItem(
      DailyResult(
        isWin: isWin,
        word: secretWord,
      ),
    );
    Statistic statistic = GetIt.I.get<Statistic>();
    GetIt.I.unregister<Statistic>();
    late GameStatistic newStatistic;
    if (isWin) {
      final attemptNumber = DictionaryData.getInstance().currentWordIndex;
      newStatistic = savedStatistic.copyWith(
        wins: savedStatistic.wins + 1,
        currentStreak: savedStatistic.currentStreak + 1,
        maxStreak: savedStatistic.currentStreak + 1 > savedStatistic.maxStreak
            ? savedStatistic.currentStreak
            : savedStatistic.maxStreak,
      );
      Tries tries = statistic.tries;
      switch (attemptNumber) {
        case 1:
          tries = tries.copyWith(first: tries.first + 1);
          break;
        case 2:
          tries = tries.copyWith(second: tries.second + 1);
          break;
        case 3:
          tries = tries.copyWith(third: tries.third + 1);
          break;
        case 4:
          tries = tries.copyWith(fourth: tries.fourth + 1);
          break;
        case 5:
          tries = tries.copyWith(fifth: tries.fifth + 1);
          break;
        case 6:
          tries = tries.copyWith(sixth: tries.sixth + 1);
          break;
        default:
          break;
      }
      final double wins = (statistic.win + 1).toDouble();
      final double losses = statistic.loses.toDouble();
      final double total = wins + losses;
      var winRate = 0.toDouble();
      if (losses == 0 && wins != 0) {
        winRate = 100.toDouble();
      } else if (losses != 0 && wins != 0) {
        winRate = (wins / total) * 100;
      }
      statistic = statistic.copyWith(
        win: statistic.win + 1,
        currentStreak: statistic.currentStreak + 1,
        maxStreak: statistic.currentStreak + 1 > statistic.maxStreak
            ? statistic.currentStreak + 1
            : statistic.maxStreak,
        tries: tries,
        winRate: winRate,
      );
    } else {
      newStatistic = savedStatistic.copyWith(
        loses: savedStatistic.loses + 1,
        currentStreak: 0,
      );
      final double wins = (statistic.win).toDouble();
      final double losses = (statistic.loses + 1).toDouble();
      final double total = wins + losses;
      var winRate = 0.toDouble();
      if (losses == 0 && wins != 0) {
        winRate = 100.toDouble();
      } else if (losses != 0 && wins != 0) {
        winRate = (wins / total) * 100;
      }
      statistic = statistic.copyWith(
        loses: statistic.loses + 1,
        currentStreak: 0,
        winRate: winRate,
      );
    }
    GetIt.I.registerLazySingleton<Statistic>(() => statistic);
    FirebaseAuth.instance.currentUser == null
        ? await StatisticRepository.getInstance().setItem(statistic)
        : await AuthRepository().updateStatistic(statistic);
    await GameStatisticRepository.getInstance().setItem(newStatistic);
    await showWinLoseDialog(
      context,
      isWin: isWin,
      word: secretWord,
      statistic: newStatistic,
    );
  } else {
    final savedItem = await DailyResultRepository.getInstance().getItem();
    final dailyWord = DictionaryData.getInstance().secretWord;
    if (savedItem != null && savedItem.word == dailyWord) {
      await showWinLoseDialog(
        context,
        isWin: savedItem.isWin,
        word: savedItem.word,
        statistic: savedStatistic,
      );
    }
  }
}

Future<void> getStatistic() async {
  Statistic statistic;
  if (FirebaseAuth.instance.currentUser != null) {
    statistic = await AuthRepository().getStatistic();
  } else {
    statistic =
        await StatisticRepository.getInstance().getItem() ?? Statistic(uid: '');
  }
  GetIt.I.registerLazySingleton<Statistic>(() => statistic);
}
