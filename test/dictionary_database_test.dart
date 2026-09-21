import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wordly/src/feature/game/data/dictionary/dictionary_database.dart';
import 'package:wordly/src/feature/game/data/dictionary/dictionary_file_native.dart';
import 'package:wordly/src/feature/game/data/dictionary/word_schedule.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('language assets coexist without a duplicate database warning', () async {
    final Directory temporary = Directory.systemTemp.createTempSync('wordly-dictionary-warning-');
    addTearDown(() => temporary.deleteSync(recursive: true));
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (_) async => temporary.path,
    );
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null),
    );
    final messages = <String>[];
    final void Function(String) previousDebugPrint = driftRuntimeOptions.debugPrint;
    driftRuntimeOptions.debugPrint = messages.add;
    addTearDown(() => driftRuntimeOptions.debugPrint = previousDebugPrint);

    final ru = DictionaryDatabase.asset('ru');
    addTearDown(ru.close);
    final en = DictionaryDatabase.asset('en');
    addTearDown(en.close);
    expect(await ru.definition('кошка'), isNotEmpty);
    expect(await en.definition('apple'), isNotEmpty);
    expect(messages, isEmpty);

    final duplicate = DictionaryDatabase.asset('ru');
    addTearDown(duplicate.close);
    expect(messages, hasLength(1));
    expect(messages.single, contains('created the database class'));
    expect(await duplicate.definition('кошка'), isNotEmpty);
  });

  test('native asset is installed once and a new release uses a separate file', () async {
    final Directory temporary = Directory.systemTemp.createTempSync('wordly-dictionary-');
    addTearDown(() => temporary.deleteSync(recursive: true));
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (_) async => temporary.path,
    );
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null),
    );
    final String first = await dictionaryFilePath('ru_test_v1', 'assets/dictionary/ru.sqlite');
    expect(File(first).readAsBytesSync(), File('assets/dictionary/ru.sqlite').readAsBytesSync());
    expect(await dictionaryFilePath('ru_test_v1', 'nonexistent-asset'), first);
    final String second = await dictionaryFilePath('ru_test_v2', 'assets/dictionary/ru.sqlite');
    expect(second, isNot(first));
    expect(File(first).existsSync(), isTrue);
    expect(File(second).existsSync(), isTrue);
  });
  for (final (language, count, example) in [('ru', 6158, 'арбуз'), ('en', 20444, 'apple')]) {
    test('$language asset supports ordered words, exact lookup and read-only SQL', () async {
      final database = DictionaryDatabase(NativeDatabase(File('assets/dictionary/$language.sqlite')));
      addTearDown(database.close);

      final List<String> words = await database.words();
      expect(words, hasLength(count));
      expect(words.toSet(), hasLength(count));
      expect(words, orderedEquals([...words]..sort()));
      final alphabet = RegExp(language == 'ru' ? r'^[а-яё]{5}$' : r'^[a-z]{5}$');
      expect(words.every(alphabet.hasMatch), isTrue);
      final List<String> levels = await database.scheduledWords(daily: false);
      final List<String> daily = await database.scheduledWords(daily: true);
      expect(levels, hasLength(count));
      expect(levels.toSet(), words.toSet(), reason: 'Levels must include every allowed word');
      expect(daily, hasLength(1000));
      expect(daily.toSet(), hasLength(daily.length));
      expect(daily.every(words.contains), isTrue);
      final WordSchedule schedule = await database.schedule();
      expect([for (var i = 1; i <= count; i++) schedule.level(i)], orderedEquals(levels));
      expect(schedule.level(count + 1), levels.first);
      expect(schedule.daily(WordSchedule.epoch.add(const Duration(days: 999))), daily.last);
      expect(schedule.daily(WordSchedule.epoch.add(const Duration(days: 1000))), daily.first);
      // v2 extends the full v1 prefix instead of replacing its assignments.
      final oldDailyCount = language == 'ru' ? 331 : 383;
      expect(daily[oldDailyCount], language == 'ru' ? 'падеж' : 'tuple');
      expect(levels[language == 'ru' ? 6148 : 20431], language == 'ru' ? 'админ' : 'allus');
      expect(
        daily.take(10),
        language == 'ru'
            ? ['лопух', 'наука', 'такси', 'шорох', 'весло', 'халат', 'ручка', 'банка', 'лимон', 'диван']
            : ['stage', 'arena', 'curve', 'death', 'brush', 'nurse', 'court', 'dough', 'point', 'sugar'],
      );
      expect(
        levels.take(10),
        language == 'ru'
            ? ['жирши', 'фотон', 'смоль', 'сарай', 'сверк', 'лобио', 'бубон', 'либра', 'попил', 'гогот']
            : ['jaups', 'yidam', 'kiaat', 'usury', 'matey', 'molts', 'resps', 'bluds', 'toras', 'profs'],
      );
      expect(await database.definition(example), isNotEmpty);
      expect(await database.definition("' OR 1=1 --"), isNull);
      expect(await database.definition('missing-word'), isNull);
      expect(
        await database
            .customSelect("SELECT count(*) AS n FROM words WHERE trim(definition) = ''")
            .getSingle()
            .then((row) => row.read<int>('n')),
        0,
      );
      await expectLater(
        database.customStatement('DELETE FROM words WHERE word = ?', [example]),
        throwsA(isA<SqliteException>()),
      );
    });
  }
  test('reviewed definitions use the intended source sense', () async {
    final ru = DictionaryDatabase(NativeDatabase(File('assets/dictionary/ru.sqlite')));
    final en = DictionaryDatabase(NativeDatabase(File('assets/dictionary/en.sqlite')));
    addTearDown(ru.close);
    addTearDown(en.close);
    expect(await ru.definition('кошка'), contains('домашней кошки'));
    expect(await ru.definition('ведро'), isNot(contains('погода')));
    expect(await en.definition('apple'), contains('fruit'));
    expect(await en.definition('apple'), isNot(contains('computer')));
    expect(await ru.definition('админ'), contains('компьютерной сети'));
    expect(await ru.definition('профи'), contains('знаток своего дела'));
    expect(await en.definition('xword'), contains('word puzzle'));
    expect(await en.definition('scink'), contains('lizard'));
  });
}
