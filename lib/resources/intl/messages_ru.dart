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

  static String m0(attemptNumber, emoji) =>
      "У меня не получилось разгадать слово за ${attemptNumber} попыток.\n${emoji}\nА у тебя получится?\n\nТы можешь скачать игру тут:\nhttps://play.google.com/store/apps/details?id=com.carapacik.wordly\n";

  static String m1(attemptNumber, emoji) =>
      "Слово разгадано за ${attemptNumber}/6 попыток\n${emoji}\nСможешь повторить мой результат?\n\nТы можешь скачать игру тут:\nhttps://play.google.com/store/apps/details?id=com.carapacik.wordly\n";

  static String m2(number) => "Уровень ${number}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("О приложении"),
        "app_language": MessageLookupByLibrary.simpleMessage("Язык приложения"),
        "check_my_result_lose": m0,
        "check_my_result_win": m1,
        "contact": MessageLookupByLibrary.simpleMessage(
            "Если вы не нашли слово в словаре,\nнапишите нам, мы добавим его\nв следующем обновлении.\n"),
        "copy": MessageLookupByLibrary.simpleMessage("Копировать"),
        "created_by": MessageLookupByLibrary.simpleMessage("Разработано"),
        "current_streak":
            MessageLookupByLibrary.simpleMessage("Текущая\nСерия"),
        "daily": MessageLookupByLibrary.simpleMessage("Ежедневный"),
        "dark_mode": MessageLookupByLibrary.simpleMessage("Темная тема"),
        "dictionary": MessageLookupByLibrary.simpleMessage("Словарь"),
        "dictionary_language":
            MessageLookupByLibrary.simpleMessage("Язык словаря"),
        "en": MessageLookupByLibrary.simpleMessage("Английский"),
        "game_design": MessageLookupByLibrary.simpleMessage("Геймпей"),
        "guess_distribution":
            MessageLookupByLibrary.simpleMessage("Распределение догадок"),
        "high_contrast_mode": MessageLookupByLibrary.simpleMessage(
            "Режим повышенной контрастности"),
        "how_to_play": MessageLookupByLibrary.simpleMessage("Как играть"),
        "letter_correct_spot": MessageLookupByLibrary.simpleMessage(
            "  находится в слове и в нужном месте"),
        "letter_not_in_word": MessageLookupByLibrary.simpleMessage(
            "  нет в слове ни в одном месте"),
        "letter_wrong_spot": MessageLookupByLibrary.simpleMessage(
            "  есть в слове, но не в том месте"),
        "level_number": m2,
        "levels": MessageLookupByLibrary.simpleMessage("Уровни"),
        "lose_message": MessageLookupByLibrary.simpleMessage("Вы проиграли"),
        "max_streak": MessageLookupByLibrary.simpleMessage("Макс.\nСерия"),
        "message_new_word": MessageLookupByLibrary.simpleMessage(
            "subject=Словень%20-%20Новое%20слово&body=Слово%20-%0AЗначение%20-"),
        "next_level": MessageLookupByLibrary.simpleMessage("Следующий уровень"),
        "next_wordle":
            MessageLookupByLibrary.simpleMessage("Следующее слово через"),
        "not_played":
            MessageLookupByLibrary.simpleMessage("Вы не сыграли ни одной игры"),
        "played": MessageLookupByLibrary.simpleMessage("Сыграно"),
        "ru": MessageLookupByLibrary.simpleMessage("Русский"),
        "secret_word": MessageLookupByLibrary.simpleMessage("Загаданное слово"),
        "select_language":
            MessageLookupByLibrary.simpleMessage("Выберите язык"),
        "settings": MessageLookupByLibrary.simpleMessage("Настройки"),
        "share": MessageLookupByLibrary.simpleMessage("Поделиться"),
        "start": MessageLookupByLibrary.simpleMessage("Начать играть"),
        "statistic": MessageLookupByLibrary.simpleMessage("Статистика"),
        "text_copied": MessageLookupByLibrary.simpleMessage(
            "Текст скопирован в буфер обмена"),
        "the_letter": MessageLookupByLibrary.simpleMessage("Буква  "),
        "the_letters": MessageLookupByLibrary.simpleMessage("Буквы  "),
        "tutorial_text": MessageLookupByLibrary.simpleMessage(
            "Каждое загаданное слово состоит из 5-ти букв.\n\nНажмите на ВВОД, чтобы отправить слово.\n\nПосле каждого угадывания цвет плиток будет меняться, чтобы показать, насколько близко ваше предположение было к слову."),
        "view_levels":
            MessageLookupByLibrary.simpleMessage("Посмотреть уровни"),
        "view_statistic":
            MessageLookupByLibrary.simpleMessage("Посмотреть статистику"),
        "visual_design":
            MessageLookupByLibrary.simpleMessage("Визуальный дизайн"),
        "win_message": MessageLookupByLibrary.simpleMessage("Вы победили!"),
        "win_rate": MessageLookupByLibrary.simpleMessage("Показатель\nпобед"),
        "word_not_found":
            MessageLookupByLibrary.simpleMessage("Слово не найдено в словаре"),
        "word_too_short":
            MessageLookupByLibrary.simpleMessage("Слово неправильной длины"),
        "wordly_plus": MessageLookupByLibrary.simpleMessage("Словень Плюс")
      };
}
