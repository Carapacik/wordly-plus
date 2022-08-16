import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wordly/data/models/get_name_mixin.dart';
import 'package:wordly/resources/dictionary_en.dart';
import 'package:wordly/resources/dictionary_ru.dart';
import 'package:wordly/resources/resources.dart';

enum DictionaryEnum with GetNameEnumMixin {
  ru(12.5, dictionaryRu, 'ru'),
  en(10.5, dictionaryEn, 'en');

  const DictionaryEnum(this.keysNumber, this.currentDictionary, this.key);

  final double keysNumber;
  final Map<String, String> currentDictionary;
  final String key;

  static DictionaryEnum get dictionaryBySystemLocale {
    if (kIsWeb) {
      return DictionaryEnum.en;
    }
    return _toDictionaryLanguage(Locale(Platform.localeName));
  }

  @override
  String getName(BuildContext context) {
    switch (this) {
      case DictionaryEnum.ru:
        return context.r.ru;
      case DictionaryEnum.en:
        return context.r.en;
    }
  }
}

DictionaryEnum _toDictionaryLanguage(Locale locale) {
  if (locale.languageCode.contains('ru')) {
    return DictionaryEnum.ru;
  } else if (locale.languageCode.contains('en')) {
    return DictionaryEnum.en;
  }
  return DictionaryEnum.en;
}

extension DictionaryInt on int? {
  DictionaryEnum get toDictionary {
    if (this == null) {
      return DictionaryEnum.dictionaryBySystemLocale;
    }
    return DictionaryEnum.values[this!];
  }
}
