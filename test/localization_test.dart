import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wordly/src/localization/localization.dart';

void main() {
  test('English and Russian messages have identical keys and placeholders', () {
    Map<String, dynamic> read(String language) =>
        jsonDecode(File('lib/src/localization/translations/intl_$language.arb').readAsStringSync())
            as Map<String, dynamic>;
    final Map<String, dynamic> english = read('en')..removeWhere((key, value) => key.startsWith('@'));
    final Map<String, dynamic> russian = read('ru')..removeWhere((key, value) => key.startsWith('@'));
    expect(russian.keys.toSet(), english.keys.toSet());
    final placeholders = RegExp(r'\{(\w+)\}');
    for (final String key in english.keys) {
      expect((russian[key] as String).trim(), isNotEmpty, reason: key);
      expect(
        placeholders.allMatches(russian[key] as String).map((match) => match[1]).toSet(),
        placeholders.allMatches(english[key] as String).map((match) => match[1]).toSet(),
        reason: key,
      );
    }
  });

  test('regional locales resolve to supported languages', () {
    expect(Localization.resolve(const Locale('ru', 'RU')), const Locale('ru'));
    expect(Localization.resolve(const Locale('en', 'GB')), const Locale('en'));
    expect(Localization.resolve(const Locale('de', 'DE')), Localization.fallbackLocale);
  });

  testWidgets('device locale is normalized for the default dictionary', (tester) async {
    tester.platformDispatcher.localeTestValue = const Locale('ru', 'RU');
    addTearDown(tester.platformDispatcher.clearLocaleTestValue);
    expect(Localization.deviceLocale, const Locale('ru'));
    expect(Localization.supportedDictionaryLocales, contains(Localization.deviceLocale));
  });
}
