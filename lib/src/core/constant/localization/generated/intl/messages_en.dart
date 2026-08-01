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

  static String m0(attemptNumber) => "I couldn\'t guess the word in ${attemptNumber} attempts.";

  static String m1(attemptNumber) => "The word is solved in ${attemptNumber}/6 attempts.";

  static String m2(number) => "Level ${number}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("About"),
    "appDictionary": MessageLookupByLibrary.simpleMessage("App dictionary"),
    "appLanguage": MessageLookupByLibrary.simpleMessage("App language"),
    "appTitle": MessageLookupByLibrary.simpleMessage("Wordly Plus"),
    "casual": MessageLookupByLibrary.simpleMessage("Default"),
    "checkResult": MessageLookupByLibrary.simpleMessage("You can check your result here:"),
    "checkResultLose": m0,
    "checkResultWin": m1,
    "colorMode": MessageLookupByLibrary.simpleMessage("Color mode"),
    "contact": MessageLookupByLibrary.simpleMessage(
      "If you didn\'t find a word in the dictionary\nor it has the wrong definition,\nwrite to us, we will add it\nin the next update.\n",
    ),
    "currentStreak": MessageLookupByLibrary.simpleMessage("Current\nStreak"),
    "daily": MessageLookupByLibrary.simpleMessage("Daily"),
    "en": MessageLookupByLibrary.simpleMessage("English"),
    "examples": MessageLookupByLibrary.simpleMessage("Examples"),
    "guessDistribution": MessageLookupByLibrary.simpleMessage("Guess distribution"),
    "highContrast": MessageLookupByLibrary.simpleMessage("High contrast"),
    "levelNumber": m2,
    "levels": MessageLookupByLibrary.simpleMessage("Levels"),
    "loseMessage": MessageLookupByLibrary.simpleMessage("You lost"),
    "maxStreak": MessageLookupByLibrary.simpleMessage("Max\nStreak"),
    "newWordAvailableEachDay": MessageLookupByLibrary.simpleMessage("A new word will be available each day!"),
    "nextLevel": MessageLookupByLibrary.simpleMessage("Next level"),
    "nextWord": MessageLookupByLibrary.simpleMessage("Next word in"),
    "notPlayed": MessageLookupByLibrary.simpleMessage("You haven\'t played a single game"),
    "other": MessageLookupByLibrary.simpleMessage("Other"),
    "played": MessageLookupByLibrary.simpleMessage("Played"),
    "progressSaveFailed": MessageLookupByLibrary.simpleMessage(
      "Could not save progress. Your board is still available.",
    ),
    "resultUnavailable": MessageLookupByLibrary.simpleMessage("Result unavailable"),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "ru": MessageLookupByLibrary.simpleMessage("Russian"),
    "secretWord": MessageLookupByLibrary.simpleMessage("Secret word"),
    "sendMessage": MessageLookupByLibrary.simpleMessage(
      "subject=WordlyPlus%20-%20New%20word&body=Word%20-%0AMeaning%20-",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "share": MessageLookupByLibrary.simpleMessage("Share"),
    "start": MessageLookupByLibrary.simpleMessage("Start game"),
    "statistic": MessageLookupByLibrary.simpleMessage("Statistic"),
    "themeDark": MessageLookupByLibrary.simpleMessage("Dark"),
    "themeLight": MessageLookupByLibrary.simpleMessage("Light"),
    "themeMode": MessageLookupByLibrary.simpleMessage("Theme mode"),
    "themeSystem": MessageLookupByLibrary.simpleMessage("System"),
    "tutorial": MessageLookupByLibrary.simpleMessage("How to play"),
    "tutorialDescription1": MessageLookupByLibrary.simpleMessage(
      "Each guess must be a valid 5 letter word. Hit the enter button to submit.",
    ),
    "tutorialDescription2": MessageLookupByLibrary.simpleMessage(
      "After each guess, the color of the tiles will change to show how close your guess was to the word.",
    ),
    "tutorialNotInWordSpot": MessageLookupByLibrary.simpleMessage("The letter E is not in the word in any spot."),
    "tutorialTitle": MessageLookupByLibrary.simpleMessage("Guess the WORD in 6 tries."),
    "tutorialWordCorrectSpot": MessageLookupByLibrary.simpleMessage(
      "The letter P is in the word and in the correct spot.",
    ),
    "tutorialWordWrongSpot": MessageLookupByLibrary.simpleMessage("The letter A is in the word but in the wrong spot."),
    "viewLevels": MessageLookupByLibrary.simpleMessage("View levels"),
    "viewStatistic": MessageLookupByLibrary.simpleMessage("View statistic"),
    "winMessage": MessageLookupByLibrary.simpleMessage("You win!"),
    "winRate": MessageLookupByLibrary.simpleMessage("Win\nrate"),
    "wordNotFound": MessageLookupByLibrary.simpleMessage("Word not found in dictionary"),
    "wordTooShort": MessageLookupByLibrary.simpleMessage("Word is not correct length"),
  };
}
