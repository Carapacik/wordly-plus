import 'dart:ui' show Color, Locale;

import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/core/constant/localization/localization.dart';
import 'package:wordly/src/feature/settings/settings.dart';

const generalSettingsCodec = GeneralSettingsCodec();

class const GeneralSettingsCodec() extends JsonMapCodec<GeneralSettings> {
  @override
  GeneralSettings $decode(Map<String, Object?> input) {
    final themeMode = input['themeMode'] as String?;
    final colorMode = input['colorMode'] as String?;
    final locale = input['locale'] as String?;
    final otherColor1 = input['otherColor1'] as Map<String, Object?>?;
    final otherColor2 = input['otherColor2'] as Map<String, Object?>?;
    final otherColor3 = input['otherColor3'] as Map<String, Object?>?;

    Color? otherColor1Value;
    Color? otherColor2Value;
    Color? otherColor3Value;

    if (otherColor1 case {
      'r': final r as double,
      'g': final g as double,
      'b': final b as double,
      'a': final a as double,
    }) {
      otherColor1Value = Color.from(alpha: a, red: r, green: g, blue: b);
    }
    if (otherColor2 case {
      'r': final r as double,
      'g': final g as double,
      'b': final b as double,
      'a': final a as double,
    }) {
      otherColor2Value = Color.from(alpha: a, red: r, green: g, blue: b);
    }
    if (otherColor3 case {
      'r': final r as double,
      'g': final g as double,
      'b': final b as double,
      'a': final a as double,
    }) {
      otherColor3Value = Color.from(alpha: a, red: r, green: g, blue: b);
    }

    (Color, Color, Color)? otherColors;
    if (otherColor1Value != null && otherColor2Value != null && otherColor3Value != null) {
      otherColors = (otherColor1Value, otherColor2Value, otherColor3Value);
    }
    final Locale? localeValue = locale == null ? null : Locale.fromSubtags(languageCode: locale);

    final defaults = GeneralSettings(locale: Localization.computeDefaultLocale());

    return GeneralSettings(
      themeMode: themeMode != null ? ThemeModeVO.values.byName(themeMode) : defaults.themeMode,
      colorMode: colorMode != null ? ColorMode.values.byName(colorMode) : defaults.colorMode,
      otherColors: otherColors,
      locale: localeValue ?? defaults.locale,
    );
  }

  @override
  Map<String, Object?> $encode(GeneralSettings input) {
    return {
      'locale': input.locale.languageCode,
      'themeMode': input.themeMode.name,
      'colorMode': input.colorMode.name,
      if (input.otherColors != null)
        'otherColor1': {
          'r': input.otherColors!.$1.r,
          'g': input.otherColors!.$1.g,
          'b': input.otherColors!.$1.b,
          'a': input.otherColors!.$1.a,
        },
      if (input.otherColors != null)
        'otherColor2': {
          'r': input.otherColors!.$2.r,
          'g': input.otherColors!.$2.g,
          'b': input.otherColors!.$2.b,
          'a': input.otherColors!.$2.a,
        },
      if (input.otherColors != null)
        'otherColor3': {
          'r': input.otherColors!.$3.r,
          'g': input.otherColors!.$3.g,
          'b': input.otherColors!.$3.b,
          'a': input.otherColors!.$3.a,
        },
    };
  }
}
