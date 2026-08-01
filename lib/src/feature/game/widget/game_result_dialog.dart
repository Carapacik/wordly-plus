import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:share_plus/share_plus.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/game/domain/model/game_mode.dart';
import 'package:wordly/src/feature/game/domain/model/letter_info.dart';
import 'package:wordly/src/feature/game/widget/countdown_timer.dart';
import 'package:wordly/src/feature/settings/settings.dart';

Future<void> showGameResultDialog(
  BuildContext context,
  String secretWord,
  String meaning,
  GameMode mode, {
  required bool isWin,
  required VoidCallback nextLevelPressed,
  String? shareString,
  VoidCallback? onTimerEnd,
}) => showDialog(
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

class DialogContent extends StatelessWidget {
  const DialogContent({
    required this.secretWord,
    required this.meaning,
    required this.isWin,
    required this.mode,
    required this.shareString,
    required this.onTimerEnd,
    required this.nextLevelPressed,
    super.key,
  });

  final String secretWord;
  final String meaning;
  final bool isWin;
  final GameMode mode;
  final String? shareString;
  final VoidCallback? onTimerEnd;
  final VoidCallback nextLevelPressed;

  @override
  Widget build(BuildContext context) {
    final Settings settings = SettingsScope.of(context, listen: true).settingsService.current;
    final LetterStatus resultStatus = isWin ? LetterStatus.correctSpot : LetterStatus.notInWord;
    final Color backgroundColor = resultStatus.cellColor(context, settings.general);
    final Color textColor = resultStatus.textColor(context, settings.general) ?? Colors.white;
    final double width = MediaQuery.sizeOf(context).width;
    final num padding = width > 350 ? (width - 350) / 2 : 8;
    return Dialog(
      backgroundColor: backgroundColor,
      insetAnimationDuration: const Duration(milliseconds: 800),
      insetPadding: EdgeInsets.symmetric(horizontal: padding.toDouble()),
      child: Padding(
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

class _DailyContent extends StatelessWidget {
  const _DailyContent({required this.resultColor, required this.textColor, required this.shareString, this.onEnd});

  final Color resultColor;
  final Color textColor;
  final VoidCallback? onEnd;
  final String? shareString;

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

class _LevelContent extends StatelessWidget {
  const _LevelContent({required this.resultColor, required this.nextLevelPressed});

  final Color resultColor;
  final VoidCallback nextLevelPressed;

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
