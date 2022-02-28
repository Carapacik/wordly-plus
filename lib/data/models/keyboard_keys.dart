import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:wordly/data/models/dictionary_languages.dart';

const _defaultWidthRu = 0.067;
const _defaultWidthEn = 0.08;

enum KeyboardKeys {
  q('й', 'q', LogicalKeyboardKey(1081), LogicalKeyboardKey.keyQ),
  w('ц', 'w', LogicalKeyboardKey(1094), LogicalKeyboardKey.keyW),
  e('у', 'e', LogicalKeyboardKey(1091), LogicalKeyboardKey.keyE),
  r('к', 'r', LogicalKeyboardKey(1082), LogicalKeyboardKey.keyR),
  t('е', 't', LogicalKeyboardKey(1077), LogicalKeyboardKey.keyT),
  y('н', 'y', LogicalKeyboardKey(1085), LogicalKeyboardKey.keyY),
  u('г', 'u', LogicalKeyboardKey(1075), LogicalKeyboardKey.keyU),
  i('ш', 'i', LogicalKeyboardKey(1096), LogicalKeyboardKey.keyI),
  o('щ', 'o', LogicalKeyboardKey(1097), LogicalKeyboardKey.keyO),
  p('з', 'p', LogicalKeyboardKey(1079), LogicalKeyboardKey.keyP),
  a1('х', null, LogicalKeyboardKey(1093), null),
  a2('ъ', null, LogicalKeyboardKey(1098), null),
  a('ф', 'a', LogicalKeyboardKey(1092), LogicalKeyboardKey.keyA),
  s('ы', 's', LogicalKeyboardKey(1099), LogicalKeyboardKey.keyS),
  d('в', 'd', LogicalKeyboardKey(1074), LogicalKeyboardKey.keyD),
  f('а', 'f', LogicalKeyboardKey(1072), LogicalKeyboardKey.keyF),
  g('п', 'g', LogicalKeyboardKey(1087), LogicalKeyboardKey.keyG),
  h('р', 'h', LogicalKeyboardKey(1088), LogicalKeyboardKey.keyH),
  j('о', 'j', LogicalKeyboardKey(1086), LogicalKeyboardKey.keyJ),
  k('л', 'k', LogicalKeyboardKey(1083), LogicalKeyboardKey.keyK),
  l('д', 'l', LogicalKeyboardKey(1076), LogicalKeyboardKey.keyL),
  b1('ж', null, LogicalKeyboardKey(1078), null),
  b2('э', null, LogicalKeyboardKey(1101), null),
  z('я', 'z', LogicalKeyboardKey(1103), LogicalKeyboardKey.keyZ),
  x('ч', 'x', LogicalKeyboardKey(1095), LogicalKeyboardKey.keyX),
  c('с', 'c', LogicalKeyboardKey(1089), LogicalKeyboardKey.keyC),
  v('м', 'v', LogicalKeyboardKey(1084), LogicalKeyboardKey.keyV),
  b('и', 'b', LogicalKeyboardKey(1080), LogicalKeyboardKey.keyB),
  n('т', 'n', LogicalKeyboardKey(1090), LogicalKeyboardKey.keyN),
  m('ь', 'm', LogicalKeyboardKey(1100), LogicalKeyboardKey.keyM),
  c1('б', null, LogicalKeyboardKey(1073), null),
  c2('ю', null, LogicalKeyboardKey(1102), null),
  enter('ввод', 'enter', null, null),
  delete('удалить', 'delete', null, null);

  const KeyboardKeys(
    this.ruName,
    this.enName,
    this.ruKey,
    this.enKey,
  );

  final String? ruName;
  final LogicalKeyboardKey? ruKey;
  final String? enName;
  final LogicalKeyboardKey? enKey;

  static KeyboardKeys? fromLogicalKey(final LogicalKeyboardKey logicalKey) =>
      KeyboardKeys.values.firstWhereOrNull(
        (element) => element._notNullKeys.contains(logicalKey),
      );

  String? fromDictionaryLang(DictionaryLanguages lang) {
    switch (lang) {
      case DictionaryLanguages.ru:
        return ruName;
      case DictionaryLanguages.en:
        return enName;
    }
  }

  double width({
    required DictionaryLanguages language,
    required double screenWidth,
  }) {
    final parentWidth = screenWidth > 400 ? 400 : screenWidth;
    if (this == KeyboardKeys.delete) {
      switch (language) {
        case DictionaryLanguages.ru:
          return parentWidth * _defaultWidthRu / 2 * 3.5;
        case DictionaryLanguages.en:
          return parentWidth * _defaultWidthEn / 2 * 2.8;
      }
    }
    if (this == KeyboardKeys.enter) {
      switch (language) {
        case DictionaryLanguages.ru:
          return parentWidth * _defaultWidthRu / 2 * 3.5;
        case DictionaryLanguages.en:
          return parentWidth * _defaultWidthEn / 2 * 2.8;
      }
    }
    switch (language) {
      case DictionaryLanguages.ru:
        return parentWidth * _defaultWidthRu;
      case DictionaryLanguages.en:
        return parentWidth * _defaultWidthEn;
    }
  }

  List<LogicalKeyboardKey> get _notNullKeys {
    final list = <LogicalKeyboardKey>[];
    if (ruKey != null) {
      list.add(ruKey!);
    }
    if (enKey != null) {
      list.add(enKey!);
    }
    return list;
  }
}
