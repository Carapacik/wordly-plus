import 'package:flutter/material.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/core/resources/resources.dart';

enum ThemeModeVO() {
  light,
  dark,
  system;

  ThemeMode toMaterialThemeMode() => switch (this) {
    ThemeModeVO.system => ThemeMode.system,
    ThemeModeVO.light => ThemeMode.light,
    ThemeModeVO.dark => ThemeMode.dark,
  };
}

enum ColorMode() {
  casual,
  highContrast,
  other;

  String localized(BuildContext context) => switch (this) {
    ColorMode.casual => context.l10n.casual,
    ColorMode.highContrast => context.l10n.highContrast,
    ColorMode.other => context.l10n.other,
  };
}

@immutable
final class const GeneralSettings({
  required final Locale locale,
  final ThemeModeVO themeMode = ThemeModeVO.system,
  final ColorMode colorMode = ColorMode.casual,
  final (Color, Color, Color)? otherColors,
}) {
  GeneralSettings copyWith({
    ThemeModeVO? themeMode,
    ColorMode? colorMode,
    (Color, Color, Color)? otherColors,
    Locale? locale,
  }) => GeneralSettings(
    themeMode: themeMode ?? this.themeMode,
    colorMode: colorMode ?? this.colorMode,
    otherColors: otherColors ?? this.otherColors,
    locale: locale ?? this.locale,
  );

  Color get correctColor => switch (colorMode) {
    ColorMode.casual => AppColors.green,
    ColorMode.highContrast => AppColors.orange,
    ColorMode.other => otherColors?.$1 ?? AppColors.green,
  };

  Color get wrongSpotColor => switch (colorMode) {
    ColorMode.casual => AppColors.yellow,
    ColorMode.highContrast => AppColors.blue,
    ColorMode.other => otherColors?.$2 ?? AppColors.yellow,
  };

  Color notInWordColor(BuildContext context) {
    final bool isDark = isDarkTheme(context);
    if (colorMode case ColorMode.casual || ColorMode.highContrast) {
      return isDark ? AppColors.tertiary : AppColors.grey;
    }
    return otherColors?.$3 ?? (isDark ? AppColors.tertiary : AppColors.grey);
  }

  Color unknownColor(BuildContext context) => isDarkTheme(context) ? AppColors.grey : AppColors.tertiary;

  bool isDarkTheme(BuildContext context) => context.theme.brightness == Brightness.dark;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneralSettings &&
          themeMode == other.themeMode &&
          colorMode == other.colorMode &&
          locale == other.locale &&
          (colorMode != ColorMode.other || _colorsEqual(otherColors, other.otherColors));

  @override
  int get hashCode =>
      Object.hash(themeMode, colorMode, locale, colorMode == ColorMode.other ? _colorsHash(otherColors) : 0);

  bool _colorsEqual((Color, Color, Color)? a, (Color, Color, Color)? b) {
    if (identical(a, b)) {
      return true;
    }
    if (a == null || b == null) {
      return false;
    }

    return a.$1.toARGB32() == b.$1.toARGB32() &&
        a.$2.toARGB32() == b.$2.toARGB32() &&
        a.$3.toARGB32() == b.$3.toARGB32();
  }

  int _colorsHash((Color, Color, Color)? c) {
    if (c == null) {
      return 0;
    }

    return Object.hash(c.$1.toARGB32(), c.$2.toARGB32(), c.$3.toARGB32());
  }
}

@immutable
class const ChangeColorResult({final ColorMode colorMode = ColorMode.casual, final (Color, Color, Color)? otherColors});
