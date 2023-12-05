import 'package:flutter/material.dart';
import 'package:wordly/src/feature/game/domain/model/letter_info.dart';
import 'package:wordly/src/feature/settings/settings.dart';

Future<void> showLevelDialog(
  BuildContext context, {
  required String word,
  required String meaning,
  required bool isWin,
}) => showDialog<void>(
  context: context,
  builder: (context) {
    final Settings settings = SettingsScope.of(context, listen: true).settingsService.current;
    final LetterStatus status = isWin ? LetterStatus.correctSpot : LetterStatus.notInWord;
    final Color textColor = status.textColor(context, settings.general) ?? Colors.white;
    final double width = MediaQuery.sizeOf(context).width;
    final num padding = width > 350 ? (width - 350) / 2 : 8;
    return Dialog(
      backgroundColor: status.cellColor(context, settings.general),
      insetAnimationDuration: const Duration(milliseconds: 800),
      insetPadding: EdgeInsets.symmetric(horizontal: padding.toDouble()),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SelectableText(word.toUpperCase(), style: TextStyle(color: textColor, fontSize: 24)),
            const SizedBox(height: 16),
            Text(
              meaning,
              style: TextStyle(color: textColor, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  },
);
