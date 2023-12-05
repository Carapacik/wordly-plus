import 'dart:ui' show Color;

extension HexColorX on String {
  Color get fromHexToColor {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) {
      buffer.write('ff');
    }
    buffer.write(replaceFirst('#', ''));
    return Color(int.tryParse(buffer.toString(), radix: 16) ?? 0x00000000);
  }

  Color? toColor() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) {
      buffer.write('FF');
    }
    buffer.write(replaceFirst('#', ''));
    final int? colorValue = int.tryParse(buffer.toString(), radix: 16);
    if (colorValue == null) {
      return null;
    }
    return Color(colorValue);
  }
}
