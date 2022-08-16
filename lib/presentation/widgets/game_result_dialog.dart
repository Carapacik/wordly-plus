import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/bloc/game/game_bloc.dart';
import 'package:wordly/data/models.dart';
import 'package:wordly/presentation/pages/game/game_page.dart';
import 'package:wordly/presentation/widgets/widgets.dart';
import 'package:wordly/resources/resources.dart';
import 'package:wordly/utils/utils.dart';

void showGameResultDialog(
  BuildContext context, {
  required GameResult result,
  required bool isDailyMode,
}) {
  unawaited(
    showDialog<void>(
      context: context,
      builder: (context) {
        if (result.isWin == null) {
          return const SizedBox.shrink();
        }
        return Dialog(
          backgroundColor: result.isWin!
              ? context.dynamicColor(
                  light: AppColors.greenLight,
                  dark: AppColors.greenDark,
                )
              : context.dynamicColor(
                  light: AppColors.redLight,
                  dark: AppColors.redDark,
                ),
          insetPadding:
              EdgeInsets.symmetric(horizontal: horizontalPadding(context)),
          insetAnimationDuration: const Duration(milliseconds: 500),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  result.isWin!
                      ? context.r.win_message.toUpperCase()
                      : context.r.lose_message.toUpperCase(),
                  style: context.theme.tlb.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  context.r.secret_word,
                  style: context.theme.bl.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  result.word.toUpperCase(),
                  style: context.theme.tmb.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  result.meaning,
                  style: context.theme.ll.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                if (isDailyMode)
                  _DailyContent(isWin: result.isWin!)
                else
                  _LevelContent(isWin: result.isWin!),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class _DailyContent extends StatelessWidget {
  // ignore: unused_element
  const _DailyContent({required this.isWin, super.key});

  final bool isWin;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final timeRemaining = tomorrow.difference(now);
    final gameBloc = context.read<GameBloc>();
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            final textFunction = isWin
                ? context.r.check_my_result_win
                : context.r.check_my_result_lose;
            gameBloc.add(GameEvent.share(textFunction: textFunction));
          },
          child: Text(
            context.r.share,
            style: context.theme.blb.copyWith(
              color: isWin
                  ? context.dynamicColor(
                      light: AppColors.greenLight,
                      dark: AppColors.greenDark,
                    )
                  : context.dynamicColor(
                      light: AppColors.redLight,
                      dark: AppColors.redDark,
                    ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.r.next_wordle,
          style: context.theme.bl.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 8),
        CountdownTimer(
          onEnd: () {
            Navigator.of(context).pop();
            gameBloc.add(const GameEvent.loadGame());
          },
          timeRemaining: timeRemaining,
        ),
      ],
    );
  }
}

class _LevelContent extends StatelessWidget {
  // ignore: unused_element
  const _LevelContent({required this.isWin, super.key});

  final bool isWin;

  @override
  Widget build(BuildContext context) {
    final gameBloc = context.read<GameBloc>();
    return Column(
      children: [
        SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: () async {
              gameBloc.add(const GameEvent.loadGame(isDaily: false));
              await Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(
                  builder: (context) => const GamePage(isDailyMode: false),
                ),
                (route) => false,
              );
            },
            child: Text(
              context.r.next_level,
              style: context.theme.blb.copyWith(
                color: isWin
                    ? context.dynamicColor(
                        light: AppColors.greenLight,
                        dark: AppColors.greenDark,
                      )
                    : context.dynamicColor(
                        light: AppColors.redLight,
                        dark: AppColors.redDark,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
