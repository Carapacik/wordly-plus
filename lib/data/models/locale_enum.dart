import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wordly/data/models/get_name_mixin.dart';
import 'package:wordly/resources/resources.dart';

enum LocaleEnum with GetNameEnumMixin {
  ru._(Locale('ru'), ['пауза', 'фишка', 'лейка']),
  en._(Locale('en'), ['pause', 'crane', 'spore']);

  const LocaleEnum._(this.locale, this.examplesList);

  final Locale locale;
  final List<String> examplesList;

  static LocaleEnum get getSystemLocaleByLanguage {
    if (kIsWeb) {
      return LocaleEnum.en;
    }
    return _toLocaleLanguages(Locale(Platform.localeName));
  }

  @override
  String getName(BuildContext context) {
    switch (this) {
      case LocaleEnum.ru:
        return context.r.ru;
      case LocaleEnum.en:
        return context.r.en;
    }
  }
}

LocaleEnum _toLocaleLanguages(Locale locale) {
  if (locale.languageCode.contains('ru')) {
    return LocaleEnum.ru;
  } else if (locale.languageCode.contains('en')) {
    return LocaleEnum.en;
  } else {
    return LocaleEnum.en;
  }
}

extension LocaleInt on int? {
  LocaleEnum get toLocale {
    if (this == null) {
      return LocaleEnum.getSystemLocaleByLanguage;
    }
    return LocaleEnum.values[this!];
  }
}
