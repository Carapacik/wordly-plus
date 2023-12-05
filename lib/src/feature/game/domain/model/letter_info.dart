import 'package:flutter/material.dart';
import 'package:wordly/src/core/common/src/utils/color.dart';
import 'package:wordly/src/core/resources/resources.dart';
import 'package:wordly/src/feature/settings/settings.dart';

@immutable
class const LetterInfo({required final String letter, final LetterStatus status = LetterStatus.unknown}) {
  factory fromJson(Map<String, dynamic> json) =>
      LetterInfo(letter: json['letter'] as String, status: LetterStatus.values[json['status'] as int]);

  Map<String, Object?> toJson() => <String, Object?>{'letter': letter, 'status': status.index};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LetterInfo && runtimeType == other.runtimeType && letter == other.letter && status == other.status;

  @override
  int get hashCode => letter.hashCode ^ status.hashCode;

  @override
  String toString() => '($letter ${status.emoji})';
}

enum LetterStatus() {
  correctSpot,
  wrongSpot,
  notInWord,
  unknown;

  bool operator <(LetterStatus other) => other.index < index;

  Color cellColor(BuildContext context, GeneralSettings settings) {
    return switch (this) {
      LetterStatus.correctSpot => settings.correctColor,
      LetterStatus.wrongSpot => settings.wrongSpotColor,
      LetterStatus.notInWord => settings.notInWordColor(context),
      LetterStatus.unknown => settings.unknownColor(context),
    };
  }

  Color? textColor(BuildContext context, GeneralSettings settings) {
    final bool isDark = settings.isDarkTheme(context);
    final Color color = cellColor(context, settings);

    // other mode not in word always darken
    if (settings.colorMode == ColorMode.other && this == LetterStatus.notInWord) {
      return darken(color, 0.3);
    }
    // for empty basic tiles
    if (this == LetterStatus.notInWord || this == LetterStatus.unknown) {
      final bool primary = !isDark && this == LetterStatus.notInWord || isDark && this == LetterStatus.unknown;
      return primary ? AppColors.secondary : AppColors.primary;
    }
    // for high contrast
    if (settings.colorMode == ColorMode.highContrast) {
      return Colors.white;
    }
    return darken(color, 0.3);
  }

  String get emoji => switch (this) {
    LetterStatus.correctSpot => '🟩',
    LetterStatus.wrongSpot => '🟨',
    LetterStatus.notInWord => '⬛',
    LetterStatus.unknown => '',
  };
}
