import 'dart:ui';

Locale getLocaleFromString(final String locale) {
  switch (locale) {
    case "ru":
      return const Locale("ru");
    case "en":
    default:
      return const Locale("en");
  }
}
