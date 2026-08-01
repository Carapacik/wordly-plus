// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(attemptNumber) =>
      "У меня не получилось разгадать слово за ${attemptNumber} попыток.";

  static String m1(attemptNumber) =>
      "Я угадал слово за ${attemptNumber}/6 попыток.";

  static String m2(number) => "Уровень ${number}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("О приложении"),
    "appDictionary": MessageLookupByLibrary.simpleMessage("Язык словаря"),
    "appLanguage": MessageLookupByLibrary.simpleMessage("Язык приложения"),
    "appTitle": MessageLookupByLibrary.simpleMessage("Словень Плюс"),
    "casual": MessageLookupByLibrary.simpleMessage("Обычный"),
    "checkResult": MessageLookupByLibrary.simpleMessage(
      "Можешь проверить свой результат тут:",
    ),
    "checkResultLose": m0,
    "checkResultWin": m1,
    "colorMode": MessageLookupByLibrary.simpleMessage("Цветовой режим"),
    "contact": MessageLookupByLibrary.simpleMessage(
      "Если вы не нашли слово в словаре\nили оно имеет неправильное определение,\nнапишите нам, мы добавим его\nв следующем обновлении.\n",
    ),
    "currentStreak": MessageLookupByLibrary.simpleMessage("Текущая\nСерия"),
    "daily": MessageLookupByLibrary.simpleMessage("Ежедневный"),
    "en": MessageLookupByLibrary.simpleMessage("Английский"),
    "examples": MessageLookupByLibrary.simpleMessage("Примеры"),
    "guessDistribution": MessageLookupByLibrary.simpleMessage(
      "Распределение догадок",
    ),
    "highContrast": MessageLookupByLibrary.simpleMessage("Высокий контраст"),
    "levelNumber": m2,
    "levels": MessageLookupByLibrary.simpleMessage("Уровни"),
    "loseMessage": MessageLookupByLibrary.simpleMessage("Вы проиграли"),
    "maxStreak": MessageLookupByLibrary.simpleMessage("Макс.\nСерия"),
    "newWordAvailableEachDay": MessageLookupByLibrary.simpleMessage(
      "Новое слово будет доступно каждый день!",
    ),
    "nextLevel": MessageLookupByLibrary.simpleMessage("Следующий уровень"),
    "nextWord": MessageLookupByLibrary.simpleMessage("Следующее слово через"),
    "notPlayed": MessageLookupByLibrary.simpleMessage(
      "Вы не сыграли ни одной игры",
    ),
    "other": MessageLookupByLibrary.simpleMessage("Другой"),
    "played": MessageLookupByLibrary.simpleMessage("Сыграно"),
    "progressSaveFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось сохранить прогресс. Текущая доска не потеряна.",
    ),
    "resultUnavailable": MessageLookupByLibrary.simpleMessage(
      "Результат недоступен",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Повторить"),
    "ru": MessageLookupByLibrary.simpleMessage("Русский"),
    "secretWord": MessageLookupByLibrary.simpleMessage("Загаданное слово"),
    "sendMessage": MessageLookupByLibrary.simpleMessage(
      "subject=WordlyPlus%20-%20Новое%20слово&body=Слово%20-%0AЗначение%20-",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Настройки"),
    "share": MessageLookupByLibrary.simpleMessage("Поделиться"),
    "start": MessageLookupByLibrary.simpleMessage("Начать играть"),
    "statistic": MessageLookupByLibrary.simpleMessage("Статистика"),
    "themeDark": MessageLookupByLibrary.simpleMessage("Темная"),
    "themeLight": MessageLookupByLibrary.simpleMessage("Светлая"),
    "themeMode": MessageLookupByLibrary.simpleMessage("Тема"),
    "themeSystem": MessageLookupByLibrary.simpleMessage("Системная"),
    "tutorial": MessageLookupByLibrary.simpleMessage("Как играть"),
    "tutorialDescription1": MessageLookupByLibrary.simpleMessage(
      "Каждое предположение должно быть словом из 5 букв. Нажмите кнопку ввода, чтобы отправить.",
    ),
    "tutorialDescription2": MessageLookupByLibrary.simpleMessage(
      "После каждого угадывания цвет плиток будет меняться, чтобы показать, насколько близко ваше предположение было к слову.",
    ),
    "tutorialNotInWordSpot": MessageLookupByLibrary.simpleMessage(
      "Буквы А нет в слове ни в одном месте.",
    ),
    "tutorialTitle": MessageLookupByLibrary.simpleMessage(
      "Угадайте СЛОВО за 6 попыток.",
    ),
    "tutorialWordCorrectSpot": MessageLookupByLibrary.simpleMessage(
      "Буква П есть в слове и в нужном месте.",
    ),
    "tutorialWordWrongSpot": MessageLookupByLibrary.simpleMessage(
      "Буква Ш есть в слове, но не в том месте.",
    ),
    "viewLevels": MessageLookupByLibrary.simpleMessage("Посмотреть уровни"),
    "viewStatistic": MessageLookupByLibrary.simpleMessage(
      "Посмотреть статистику",
    ),
    "winMessage": MessageLookupByLibrary.simpleMessage("Вы победили!"),
    "winRate": MessageLookupByLibrary.simpleMessage("Показатель\nпобед"),
    "wordNotFound": MessageLookupByLibrary.simpleMessage(
      "Слово не найдено в словаре",
    ),
    "wordTooShort": MessageLookupByLibrary.simpleMessage(
      "Слово неправильной длины",
    ),
  };
}
