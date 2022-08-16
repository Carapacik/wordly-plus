// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class R {
  R();

  static R? _current;

  static R get current {
    assert(_current != null,
        'No instance of R was loaded. Try to initialize the R delegate before accessing R.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<R> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = R();
      R._current = instance;

      return instance;
    });
  }

  static R of(BuildContext context) {
    final instance = R.maybeOf(context);
    assert(instance != null,
        'No instance of R present in the widget tree. Did you add R.delegate in localizationsDelegates?');
    return instance!;
  }

  static R? maybeOf(BuildContext context) {
    return Localizations.of<R>(context, R);
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `App language`
  String get app_language {
    return Intl.message(
      'App language',
      name: 'app_language',
      desc: '',
      args: [],
    );
  }

  /// `I couldn't guess the word in {attemptNumber} attempts.\n{emoji}\nCan you do it?\n\nYou can download the game here:\nhttps://play.google.com/store/apps/details?id=com.carapacik.wordly\n`
  String check_my_result_lose(Object attemptNumber, Object emoji) {
    return Intl.message(
      'I couldn\'t guess the word in $attemptNumber attempts.\n$emoji\nCan you do it?\n\nYou can download the game here:\nhttps://play.google.com/store/apps/details?id=com.carapacik.wordly\n',
      name: 'check_my_result_lose',
      desc: '',
      args: [attemptNumber, emoji],
    );
  }

  /// `The word is solved in {attemptNumber}/6 attempts\n{emoji}\nCan you repeat my result?\n\nYou can download the game here:\nhttps://play.google.com/store/apps/details?id=com.carapacik.wordly\n`
  String check_my_result_win(Object attemptNumber, Object emoji) {
    return Intl.message(
      'The word is solved in $attemptNumber/6 attempts\n$emoji\nCan you repeat my result?\n\nYou can download the game here:\nhttps://play.google.com/store/apps/details?id=com.carapacik.wordly\n',
      name: 'check_my_result_win',
      desc: '',
      args: [attemptNumber, emoji],
    );
  }

  /// `If you didn't find a word in the dictionary,\nwrite to us, we will add it\nin the next update.\n`
  String get contact {
    return Intl.message(
      'If you didn\'t find a word in the dictionary,\nwrite to us, we will add it\nin the next update.\n',
      name: 'contact',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Created by`
  String get created_by {
    return Intl.message(
      'Created by',
      name: 'created_by',
      desc: '',
      args: [],
    );
  }

  /// `Current\nStreak`
  String get current_streak {
    return Intl.message(
      'Current\nStreak',
      name: 'current_streak',
      desc: '',
      args: [],
    );
  }

  /// `Daily`
  String get daily {
    return Intl.message(
      'Daily',
      name: 'daily',
      desc: '',
      args: [],
    );
  }

  /// `Dark mode`
  String get dark_mode {
    return Intl.message(
      'Dark mode',
      name: 'dark_mode',
      desc: '',
      args: [],
    );
  }

  /// `Dictionary`
  String get dictionary {
    return Intl.message(
      'Dictionary',
      name: 'dictionary',
      desc: '',
      args: [],
    );
  }

  /// `Dictionary language`
  String get dictionary_language {
    return Intl.message(
      'Dictionary language',
      name: 'dictionary_language',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get en {
    return Intl.message(
      'English',
      name: 'en',
      desc: '',
      args: [],
    );
  }

  /// `Game design`
  String get game_design {
    return Intl.message(
      'Game design',
      name: 'game_design',
      desc: '',
      args: [],
    );
  }

  /// `Guess distribution`
  String get guess_distribution {
    return Intl.message(
      'Guess distribution',
      name: 'guess_distribution',
      desc: '',
      args: [],
    );
  }

  /// `High contrast mode`
  String get high_contrast_mode {
    return Intl.message(
      'High contrast mode',
      name: 'high_contrast_mode',
      desc: '',
      args: [],
    );
  }

  /// `How to play`
  String get how_to_play {
    return Intl.message(
      'How to play',
      name: 'how_to_play',
      desc: '',
      args: [],
    );
  }

  /// `  is in the word and in the correct spot`
  String get letter_correct_spot {
    return Intl.message(
      '  is in the word and in the correct spot',
      name: 'letter_correct_spot',
      desc: '',
      args: [],
    );
  }

  /// `  is not in the word in any spot`
  String get letter_not_in_word {
    return Intl.message(
      '  is not in the word in any spot',
      name: 'letter_not_in_word',
      desc: '',
      args: [],
    );
  }

  /// `  is in the word but in the wrong spot`
  String get letter_wrong_spot {
    return Intl.message(
      '  is in the word but in the wrong spot',
      name: 'letter_wrong_spot',
      desc: '',
      args: [],
    );
  }

  /// `Level {number}`
  String level_number(Object number) {
    return Intl.message(
      'Level $number',
      name: 'level_number',
      desc: '',
      args: [number],
    );
  }

  /// `Levels`
  String get levels {
    return Intl.message(
      'Levels',
      name: 'levels',
      desc: '',
      args: [],
    );
  }

  /// `You lost`
  String get lose_message {
    return Intl.message(
      'You lost',
      name: 'lose_message',
      desc: '',
      args: [],
    );
  }

  /// `Max\nStreak`
  String get max_streak {
    return Intl.message(
      'Max\nStreak',
      name: 'max_streak',
      desc: '',
      args: [],
    );
  }

  /// `subject=Wordle%20-%20New%20word&body=Word%20-%0AMeaning%20-`
  String get message_new_word {
    return Intl.message(
      'subject=Wordle%20-%20New%20word&body=Word%20-%0AMeaning%20-',
      name: 'message_new_word',
      desc: '',
      args: [],
    );
  }

  /// `Next level`
  String get next_level {
    return Intl.message(
      'Next level',
      name: 'next_level',
      desc: '',
      args: [],
    );
  }

  /// `Next wordle in`
  String get next_wordle {
    return Intl.message(
      'Next wordle in',
      name: 'next_wordle',
      desc: '',
      args: [],
    );
  }

  /// `You haven't played a single game`
  String get not_played {
    return Intl.message(
      'You haven\'t played a single game',
      name: 'not_played',
      desc: '',
      args: [],
    );
  }

  /// `Played`
  String get played {
    return Intl.message(
      'Played',
      name: 'played',
      desc: '',
      args: [],
    );
  }

  /// `Russian`
  String get ru {
    return Intl.message(
      'Russian',
      name: 'ru',
      desc: '',
      args: [],
    );
  }

  /// `Secret word`
  String get secret_word {
    return Intl.message(
      'Secret word',
      name: 'secret_word',
      desc: '',
      args: [],
    );
  }

  /// `Select a language`
  String get select_language {
    return Intl.message(
      'Select a language',
      name: 'select_language',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Start game`
  String get start {
    return Intl.message(
      'Start game',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `Statistic`
  String get statistic {
    return Intl.message(
      'Statistic',
      name: 'statistic',
      desc: '',
      args: [],
    );
  }

  /// `The text is copied to the clipboard`
  String get text_copied {
    return Intl.message(
      'The text is copied to the clipboard',
      name: 'text_copied',
      desc: '',
      args: [],
    );
  }

  /// `The letter  `
  String get the_letter {
    return Intl.message(
      'The letter  ',
      name: 'the_letter',
      desc: '',
      args: [],
    );
  }

  /// `The letter  `
  String get the_letters {
    return Intl.message(
      'The letter  ',
      name: 'the_letters',
      desc: '',
      args: [],
    );
  }

  /// `Each guess must be a valid 5-letter word.\n\nHit the ENTER button to submit.\n\nAfter each guess, the color of the tiles will change to show how close your guess was to the word.`
  String get tutorial_text {
    return Intl.message(
      'Each guess must be a valid 5-letter word.\n\nHit the ENTER button to submit.\n\nAfter each guess, the color of the tiles will change to show how close your guess was to the word.',
      name: 'tutorial_text',
      desc: '',
      args: [],
    );
  }

  /// `View levels`
  String get view_levels {
    return Intl.message(
      'View levels',
      name: 'view_levels',
      desc: '',
      args: [],
    );
  }

  /// `View statistic`
  String get view_statistic {
    return Intl.message(
      'View statistic',
      name: 'view_statistic',
      desc: '',
      args: [],
    );
  }

  /// `Visual design`
  String get visual_design {
    return Intl.message(
      'Visual design',
      name: 'visual_design',
      desc: '',
      args: [],
    );
  }

  /// `You win!`
  String get win_message {
    return Intl.message(
      'You win!',
      name: 'win_message',
      desc: '',
      args: [],
    );
  }

  /// `Win\nrate`
  String get win_rate {
    return Intl.message(
      'Win\nrate',
      name: 'win_rate',
      desc: '',
      args: [],
    );
  }

  /// `Word not found in dictionary`
  String get word_not_found {
    return Intl.message(
      'Word not found in dictionary',
      name: 'word_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Word is not correct length`
  String get word_too_short {
    return Intl.message(
      'Word is not correct length',
      name: 'word_too_short',
      desc: '',
      args: [],
    );
  }

  /// `Wordly Plus`
  String get wordly_plus {
    return Intl.message(
      'Wordly Plus',
      name: 'wordly_plus',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<R> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<R> load(Locale locale) => R.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
