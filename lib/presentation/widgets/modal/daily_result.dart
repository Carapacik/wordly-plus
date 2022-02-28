import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:wordly/bloc/main/main_cubit.dart';
import 'package:wordly/presentation/widgets/widgets.dart';
import 'package:wordly/resources/resources.dart';
import 'package:wordly/utils/utils.dart';

Future<void> showDailyResultDialog(
  final BuildContext context, {
  required final bool isWin,
  required final String word,
  required final String secretWordMeaning,
}) async {
  await showDialog<void>(
    context: context,
    builder: (context) {
      final now = DateTime.now();
      final nextMidnight =
          DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
      final endTime = now.millisecondsSinceEpoch +
          nextMidnight.difference(now).inMilliseconds;
      final mainCubit = context.read<MainCubit>();
      final countDownController = CountdownTimerController(
        endTime: endTime,
        onEnd: () {
          mainCubit.clearGameArea();
          Navigator.of(context, rootNavigator: true).pop();
        },
      );
      return AlertDialog(
        backgroundColor: isWin ? AppColors.green : AppColors.red,
        title: Center(
          child: Text(
            isWin
                ? R.stringsOf(context).win_message
                : R.stringsOf(context).lose_message,
            style: AppTypography.m25.copyWith(color: Colors.white),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        R.stringsOf(context).next_wordle,
                        textAlign: TextAlign.center,
                        style: AppTypography.m16.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      CountdownTimer(
                        controller: countDownController,
                        widgetBuilder: (_, time) {
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
                                AppTypography.m16.copyWith(color: Colors.white),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomButton(
                        text: R.stringsOf(context).share,
                        width: 80,
                        onTap: () {
                          shareEmojiString(context, isWin: isWin);
                        },
                      ),
                      const SizedBox(height: 8),
                      CustomButton(
                        text: R.stringsOf(context).copy,
                        width: 80,
                        onTap: () {
                          copyEmojiString(context, isWin: isWin);
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Text(
              R.stringsOf(context).secret_word,
              style: AppTypography.m18.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 4),
            SelectableText(
              word.toUpperCase(),
              style: AppTypography.m20.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              secretWordMeaning,
              textAlign: TextAlign.center,
              style: AppTypography.r14.copyWith(color: Colors.white),
            ),
          ],
        ),
      );
    },
  );
}
