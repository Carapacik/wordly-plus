import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

enum LocaleLanguages {
  ru._(Locale('ru')),
  en._(Locale('en'));

  const LocaleLanguages._(this.locale);

  final Locale locale;

  static LocaleLanguages getSystemLocaleLanguage() {
    if (kIsWeb) {
      return LocaleLanguages.en;
    }
    return _toLocaleLanguages(Locale(Platform.localeName));
  }

  static LocaleLanguages _toLocaleLanguages(Locale locale) {
    if (locale.languageCode.contains('ru')) {
      return LocaleLanguages.ru;
    } else if (locale.languageCode.contains('en')) {
      return LocaleLanguages.en;
    } else {
      return LocaleLanguages.en;
    }
  }
}

extension StringExt on String {
  LocaleLanguages get toLocaleLanguage {
    switch (this) {
      case 'ru':
        return LocaleLanguages.ru;
      case 'en':
      default:
        return LocaleLanguages.en;
    }
  }
}

class LocaleLanguagesConverter extends TypeConverter<LocaleLanguages, int> {
  const LocaleLanguagesConverter();

  @override
  LocaleLanguages fromIsar(final int object) => LocaleLanguages.values[object];

  @override
  int toIsar(LocaleLanguages object) => object.index;
}
