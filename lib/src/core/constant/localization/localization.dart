import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wordly/src/core/constant/localization/generated/l10n.dart';

final class const Localization._({required final Locale locale}) {
  static const AppLocalizationDelegate _delegate = GeneratedLocalizations.delegate;

  static List<Locale> get supportedLocales => _delegate.supportedLocales;

  static List<Locale> get supportedDictionaryLocales => const [
    Locale.fromSubtags(languageCode: 'en'),
    Locale.fromSubtags(languageCode: 'ru'),
  ];

  static List<LocalizationsDelegate<void>> get localizationDelegates => [
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    _delegate,
  ];

  static GeneratedLocalizations get current => _current;

  static final GeneratedLocalizations _current = GeneratedLocalizations.current;

  static Locale computeDefaultLocale({bool withDictionary = false}) {
    final Locale locale = WidgetsBinding.instance.platformDispatcher.locale;
    if (withDictionary && supportedDictionaryLocales.contains(locale)) {
      return locale;
    }

    if (_delegate.isSupported(locale)) {
      return locale;
    }

    return const Locale.fromSubtags(languageCode: 'en');
  }

  static GeneratedLocalizations of(BuildContext context) => GeneratedLocalizations.of(context);
}
