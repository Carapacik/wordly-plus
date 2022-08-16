// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(attemptNumber, emoji) =>
      "I couldn\'t guess the word in ${attemptNumber} attempts.\n${emoji}\nCan you do it?\n\nYou can download the game here:\nhttps://play.google.com/store/apps/details?id=com.carapacik.wordly\n";

  static String m1(attemptNumber, emoji) =>
      "The word is solved in ${attemptNumber}/6 attempts\n${emoji}\nCan you repeat my result?\n\nYou can download the game here:\nhttps://play.google.com/store/apps/details?id=com.carapacik.wordly\n";

  static String m2(number) => "Level ${number}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("About"),
        "app_language": MessageLookupByLibrary.simpleMessage("App language"),
        "check_my_result_lose": m0,
        "check_my_result_win": m1,
        "contact": MessageLookupByLibrary.simpleMessage(
            "If you didn\'t find a word in the dictionary,\nwrite to us, we will add it\nin the next update.\n"),
        "copy": MessageLookupByLibrary.simpleMessage("Copy"),
        "created_by": MessageLookupByLibrary.simpleMessage("Created by"),
        "current_streak":
            MessageLookupByLibrary.simpleMessage("Current\nStreak"),
        "daily": MessageLookupByLibrary.simpleMessage("Daily"),
        "dark_mode": MessageLookupByLibrary.simpleMessage("Dark mode"),
        "dictionary": MessageLookupByLibrary.simpleMessage("Dictionary"),
        "dictionary_language":
            MessageLookupByLibrary.simpleMessage("Dictionary language"),
        "en": MessageLookupByLibrary.simpleMessage("English"),
        "game_design": MessageLookupByLibrary.simpleMessage("Game design"),
        "guess_distribution":
            MessageLookupByLibrary.simpleMessage("Guess distribution"),
        "high_contrast_mode":
            MessageLookupByLibrary.simpleMessage("High contrast mode"),
        "how_to_play": MessageLookupByLibrary.simpleMessage("How to play"),
        "letter_correct_spot": MessageLookupByLibrary.simpleMessage(
            "  is in the word and in the correct spot"),
        "letter_not_in_word": MessageLookupByLibrary.simpleMessage(
            "  is not in the word in any spot"),
        "letter_wrong_spot": MessageLookupByLibrary.simpleMessage(
            "  is in the word but in the wrong spot"),
        "level_number": m2,
        "levels": MessageLookupByLibrary.simpleMessage("Levels"),
        "lose_message": MessageLookupByLibrary.simpleMessage("You lost"),
        "max_streak": MessageLookupByLibrary.simpleMessage("Max\nStreak"),
        "message_new_word": MessageLookupByLibrary.simpleMessage(
            "subject=Wordle%20-%20New%20word&body=Word%20-%0AMeaning%20-"),
        "next_level": MessageLookupByLibrary.simpleMessage("Next level"),
        "next_wordle": MessageLookupByLibrary.simpleMessage("Next wordle in"),
        "not_played": MessageLookupByLibrary.simpleMessage(
            "You haven\'t played a single game"),
        "played": MessageLookupByLibrary.simpleMessage("Played"),
        "ru": MessageLookupByLibrary.simpleMessage("Russian"),
        "secret_word": MessageLookupByLibrary.simpleMessage("Secret word"),
        "select_language":
            MessageLookupByLibrary.simpleMessage("Select a language"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "share": MessageLookupByLibrary.simpleMessage("Share"),
        "start": MessageLookupByLibrary.simpleMessage("Start game"),
        "statistic": MessageLookupByLibrary.simpleMessage("Statistic"),
        "text_copied": MessageLookupByLibrary.simpleMessage(
            "The text is copied to the clipboard"),
        "the_letter": MessageLookupByLibrary.simpleMessage("The letter  "),
        "the_letters": MessageLookupByLibrary.simpleMessage("The letter  "),
        "tutorial_text": MessageLookupByLibrary.simpleMessage(
            "Each guess must be a valid 5-letter word.\n\nHit the ENTER button to submit.\n\nAfter each guess, the color of the tiles will change to show how close your guess was to the word."),
        "view_levels": MessageLookupByLibrary.simpleMessage("View levels"),
        "view_statistic":
            MessageLookupByLibrary.simpleMessage("View statistic"),
        "visual_design": MessageLookupByLibrary.simpleMessage("Visual design"),
        "win_message": MessageLookupByLibrary.simpleMessage("You win!"),
        "win_rate": MessageLookupByLibrary.simpleMessage("Win\nrate"),
        "word_not_found": MessageLookupByLibrary.simpleMessage(
            "Word not found in dictionary"),
        "word_too_short":
            MessageLookupByLibrary.simpleMessage("Word is not correct length"),
        "wordly_plus": MessageLookupByLibrary.simpleMessage("Wordly Plus")
      };
}
