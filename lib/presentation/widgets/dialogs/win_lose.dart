import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:wordle/data/dictionary_data.dart';
import 'package:wordle/data/models/game_statistic.dart';
import 'package:wordle/presentation/widgets/adaptive_button.dart';
import 'package:wordle/resources/app_colors.dart';
import 'package:wordle/resources/app_text_styles.dart';
import 'package:wordle/resources/r.dart';
import 'package:wordle/utils/utils.dart';

Future<void> showWinLoseDialog(
  final BuildContext context, {
  required final GameStatistic statistic,
  required final String word,
  final bool isWin = true,
}) async {
  showDialog(
    context: context,
    builder: (context) {
      final now = DateTime.now();
      final nextMidnight =
          DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
      final int endTime = now.millisecondsSinceEpoch +
          nextMidnight.difference(now).inMilliseconds;
      final CountdownTimerController _countDownController =
          CountdownTimerController(
        endTime: endTime,
        onEnd: () {
          DictionaryData.getInstance().createSecretWord();
          Navigator.of(context, rootNavigator: true).pop();
        },
      );
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: isWin ? AppColors.green : AppColors.red,
        title: Center(
          child: Text(
            isWin
                ? R.stringsOf(context).win_message
                : R.stringsOf(context).lose_message,
            style: AppTextStyles.m25.copyWith(color: Colors.white),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        R.stringsOf(context).next_wordle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.m16.copyWith(color: Colors.white),
                      ),
                      CountdownTimer(
                        controller: _countDownController,
                        widgetBuilder: (_, CurrentRemainingTime? time) {
                          if (time == null) {
                            return Container();
                          }
                          final duration = Duration(
                            hours: time.hours ?? 0,
                            minutes: time.min ?? 0,
                            seconds: time.sec ?? 0,
                          );
                          return Text(
                            durationToString(duration),
                            style:
                                AppTextStyles.m16.copyWith(color: Colors.white),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: [
                      AdaptiveButton(
                        onPressed: () {
                          shareEmojiString(context);
                        },
                        child: Container(
                          width: 80,
                          alignment: Alignment.center,
                          child: Text(
                            R.stringsOf(context).share,
                            style:
                                AppTextStyles.n14.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AdaptiveButton(
                        onPressed: () {
                          copyEmojiString(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 80,
                          child: Text(
                            R.stringsOf(context).copy,
                            style:
                                AppTextStyles.n14.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Text(
              R.stringsOf(context).secret_word_is(word: word.toUpperCase()),
              style: AppTextStyles.m20.copyWith(color: Colors.white),
            ),
          ],
        ),
      );
    },
  );
}
