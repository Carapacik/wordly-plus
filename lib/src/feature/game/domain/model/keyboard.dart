import 'dart:math' show min;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardList() {
  static const (List<String>, List<String>, List<String>) enKeyboard = (
    ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
    ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
    ['z', 'x', 'c', 'v', 'b', 'n', 'm'],
  );

  static const (List<String>, List<String>, List<String>) ruKeyboard = (
    ['й', 'ц', 'у', 'к', 'е', 'н', 'г', 'ш', 'щ', 'з', 'х', 'ъ'],
    ['ф', 'ы', 'в', 'а', 'п', 'р', 'о', 'л', 'д', 'ж', 'э'],
    ['я', 'ч', 'с', 'м', 'и', 'т', 'ь', 'б', 'ю'],
  );
}

extension LocaleKeyboardX on Locale {
  double width(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    switch (languageCode) {
      case 'en':
        final int maxKeyboardLength = KeyboardList.enKeyboard.$1.length;
        return (min(screenWidth, 520) - (maxKeyboardLength + 1) * 6) / maxKeyboardLength;
      case 'ru':
        final int maxKeyboardLength = KeyboardList.ruKeyboard.$1.length;
        return (min(screenWidth, 520) - (maxKeyboardLength + 1) * 6) / maxKeyboardLength;
    }
    return 0;
  }
}

enum GameKeyboardKey(final LogicalKeyboardKey key, {required final String? enName, required final String? ruName}) {
  q(LogicalKeyboardKey.keyQ, enName: 'Q', ruName: 'Й'),
  w(LogicalKeyboardKey.keyW, enName: 'W', ruName: 'Ц'),
  e(LogicalKeyboardKey.keyE, enName: 'E', ruName: 'У'),
  r(LogicalKeyboardKey.keyR, enName: 'R', ruName: 'К'),
  t(LogicalKeyboardKey.keyT, enName: 'T', ruName: 'Е'),
  y(LogicalKeyboardKey.keyY, enName: 'Y', ruName: 'Н'),
  u(LogicalKeyboardKey.keyU, enName: 'U', ruName: 'Г'),
  i(LogicalKeyboardKey.keyI, enName: 'I', ruName: 'Ш'),
  o(LogicalKeyboardKey.keyO, enName: 'O', ruName: 'Щ'),
  p(LogicalKeyboardKey.keyP, enName: 'P', ruName: 'З'),
  bl(LogicalKeyboardKey.bracketLeft, enName: null, ruName: 'Х'),
  br(LogicalKeyboardKey.bracketRight, enName: null, ruName: 'Ъ'),
  a(LogicalKeyboardKey.keyA, enName: 'A', ruName: 'Ф'),
  s(LogicalKeyboardKey.keyS, enName: 'S', ruName: 'Ы'),
  d(LogicalKeyboardKey.keyD, enName: 'D', ruName: 'В'),
  f(LogicalKeyboardKey.keyF, enName: 'F', ruName: 'А'),
  g(LogicalKeyboardKey.keyG, enName: 'G', ruName: 'П'),
  h(LogicalKeyboardKey.keyH, enName: 'H', ruName: 'Р'),
  j(LogicalKeyboardKey.keyJ, enName: 'J', ruName: 'О'),
  k(LogicalKeyboardKey.keyK, enName: 'K', ruName: 'Л'),
  l(LogicalKeyboardKey.keyL, enName: 'L', ruName: 'Д'),
  sc(LogicalKeyboardKey.semicolon, enName: null, ruName: 'Ж'),
  qs(LogicalKeyboardKey.quoteSingle, enName: null, ruName: 'Э'),
  z(LogicalKeyboardKey.keyZ, enName: 'Z', ruName: 'Я'),
  x(LogicalKeyboardKey.keyX, enName: 'X', ruName: 'Ч'),
  c(LogicalKeyboardKey.keyC, enName: 'C', ruName: 'С'),
  v(LogicalKeyboardKey.keyV, enName: 'V', ruName: 'М'),
  b(LogicalKeyboardKey.keyB, enName: 'B', ruName: 'И'),
  n(LogicalKeyboardKey.keyN, enName: 'N', ruName: 'Т'),
  m(LogicalKeyboardKey.keyM, enName: 'M', ruName: 'Ь'),
  cm(LogicalKeyboardKey.comma, enName: null, ruName: 'Б'),
  pr(LogicalKeyboardKey.period, enName: null, ruName: 'Ю');

  static String? toLetter(LogicalKeyboardKey logicalKey, Locale dictionary) {
    final GameKeyboardKey? gameKey = GameKeyboardKey.values.firstWhereOrNull((e) => e.key == logicalKey);
    if (gameKey == null) {
      return null;
    }
    return switch (dictionary.languageCode) {
      'en' => gameKey.enName,
      'ru' => gameKey.ruName,
      _ => gameKey.enName,
    };
  }
}
