import 'package:flutter/material.dart';
import 'package:wordly/resources/colors.dart';

enum LetterStatus { unknown, notInWords, wrongSpot, correctSpot }

extension LetterStatusExtension on LetterStatus {
  Color color(final BuildContext context, {final bool highContrast = false}) {
    switch (this) {
      case LetterStatus.unknown:
        return Theme.of(context).cardColor;
      case LetterStatus.notInWords:
        return Theme.of(context).shadowColor;
      case LetterStatus.wrongSpot:
        return highContrast ? AppColors.highContrastBlue : AppColors.yellow;
      case LetterStatus.correctSpot:
        return highContrast ? AppColors.highContrastOrange : AppColors.green;
    }
  }

  Color itemColor(
    final BuildContext context, {
    final bool isHighContrast = false,
  }) {
    switch (this) {
      case LetterStatus.unknown:
        return Colors.transparent;
      case LetterStatus.notInWords:
        return Theme.of(context).colorScheme.secondary;
      case LetterStatus.wrongSpot:
        return isHighContrast ? AppColors.highContrastBlue : AppColors.yellow;
      case LetterStatus.correctSpot:
        return isHighContrast ? AppColors.highContrastOrange : AppColors.green;
    }
  }

  String toEmoji() {
    switch (this) {
      case LetterStatus.unknown:
      case LetterStatus.notInWords:
        return '⬛';
      case LetterStatus.wrongSpot:
        return '🟨';
      case LetterStatus.correctSpot:
        return '🟩';
    }
  }
}
