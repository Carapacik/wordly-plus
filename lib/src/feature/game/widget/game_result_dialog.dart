import 'dart:async';

import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wordly/src/feature/game/model/game_mode.dart';
import 'package:wordly/src/feature/game/model/letter_info.dart';
import 'package:wordly/src/feature/game/widget/countdown_timer.dart';
import 'package:wordly/src/feature/settings/model/settings.dart';
import 'package:wordly/src/feature/settings/widget/settings_scope.dart';
import 'package:wordly/src/localization/localization_context.dart';
import 'package:wordly/src/ui_kit/colors.dart';

Future<void> showGameResultDialog(
  BuildContext context,
  String secretWord,
  String meaning,
  GameMode mode, {
  required bool isWin,
  required VoidCallback nextLevelPressed,
  String? shareString,
  VoidCallback? onTimerEnd,
  Stream<void>? closeWhen,
}) async {
  final NavigatorState navigator = Navigator.of(context, rootNavigator: true);
  final route = DialogRoute<void>(
    context: context,
    barrierDismissible: mode == GameMode.daily,
    builder: (context) => DialogContent(
      secretWord: secretWord,
      meaning: meaning,
      isWin: isWin,
      mode: mode,
      shareString: shareString,
      onTimerEnd: onTimerEnd,
      nextLevelPressed: nextLevelPressed,
    ),
  );
  final StreamSubscription<void>? subscription = closeWhen?.listen((_) {
    if (route.isActive) {
      navigator.removeRoute(route);
    }
  });
  try {
    await navigator.push(route);
  } finally {
    await subscription?.cancel();
  }
}

class const DialogContent({
  required final String secretWord,
  required final String meaning,
  required final bool isWin,
  required final GameMode mode,
  required final String? shareString,
  required final VoidCallback? onTimerEnd,
  required final VoidCallback nextLevelPressed,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Settings settings = SettingsScope.of(context, listen: true).settings;
    final Color backgroundColor = isWin ? LetterStatus.correctSpot.cellColor(context, settings.general) : AppColors.red;
    final Color textColor = isWin
        ? LetterStatus.correctSpot.textColor(context, settings.general) ?? Colors.white
        : Colors.white;
    final double width = MediaQuery.sizeOf(context).width;
    final num padding = width > 350 ? (width - 350) / 2 : 8;
    return Dialog(
      backgroundColor: backgroundColor,
      insetAnimationDuration: const Duration(milliseconds: 800),
      insetPadding: EdgeInsets.symmetric(horizontal: padding.toDouble()),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                (isWin ? context.l10n.winMessage : context.l10n.loseMessage).toUpperCase(),
                style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n.secretWord,
                style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              SelectableText(
                secretWord.toUpperCase(),
                style: TextStyle(color: textColor, fontSize: 32, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              Text(
                meaning,
                style: TextStyle(color: textColor, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              switch (mode) {
                GameMode.daily => _DailyContent(
                  resultColor: backgroundColor,
                  textColor: textColor,
                  shareString: shareString,
                  onEnd: onTimerEnd,
                ),
                GameMode.lvl => _LevelContent(resultColor: backgroundColor, nextLevelPressed: nextLevelPressed),
              },
            ],
          ),
        ),
      ),
    );
  }
}

class const _DailyContent({
  required final Color resultColor,
  required final Color textColor,
  required final String? shareString,
  final VoidCallback? onEnd,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now().toUtc();
    final tomorrow = DateTime.utc(now.year, now.month, now.day + 1);
    final Duration timeRemaining = tomorrow.difference(now);
    return Column(
      children: [
        if (shareString != null) ...[
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: shareString!));
              await SharePlus.instance.share(ShareParams(text: shareString));
            },
            child: Text(
              context.l10n.share,
              style: TextStyle(color: resultColor, fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
        ],
        Text(
          context.l10n.nextWord,
          style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        CountdownTimer(onEnd: onEnd, timeRemaining: timeRemaining, color: textColor),
      ],
    );
  }
}

class const _LevelContent({required final Color resultColor, required final VoidCallback nextLevelPressed})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
      onPressed: nextLevelPressed,
      child: Text(
        context.l10n.nextLevel,
        style: TextStyle(color: resultColor, fontSize: 16, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }
}
