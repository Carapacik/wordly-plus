import 'package:flutter/painting.dart';

Color darken(Color color, [double amount = 0.1]) {
  final hsl = HSLColor.fromColor(color);
  final HSLColor hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = 0.1]) {
  final hsl = HSLColor.fromColor(color);
  final HSLColor hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}
