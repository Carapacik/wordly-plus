import 'package:material_ui/material_ui.dart';
import 'package:wordly/src/feature/settings/model/general.dart';
import 'package:wordly/src/ui_kit/colors.dart';
import 'package:wordly/src/utils/color.dart';

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

  Color? textColor(BuildContext context, GeneralSettings settings, {Color? backgroundColor}) {
    final bool isDark = settings.isDarkTheme(context);
    final Color color = backgroundColor ?? cellColor(context, settings);

    if (settings.colorMode == ColorMode.other) {
      final double luminance = color.computeLuminance();
      final double blackContrast = (luminance + 0.05) / 0.05;
      final double whiteContrast = 1.05 / (luminance + 0.05);
      return blackContrast >= whiteContrast ? Colors.black : Colors.white;
    }
    if (this == LetterStatus.notInWord || this == LetterStatus.unknown) {
      final bool primary = !isDark && this == LetterStatus.notInWord || isDark && this == LetterStatus.unknown;
      return primary ? AppColors.secondary : AppColors.primary;
    }
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
