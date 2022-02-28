import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle/bloc/main/main_cubit.dart';
import 'package:wordle/bloc/settings/settings_cubit.dart';
import 'package:wordle/data/dictionary_data.dart';
import 'package:wordle/data/models/keyboard_keys.dart';
import 'package:wordle/data/models/letter_status.dart';
import 'package:wordle/resources/app_text_styles.dart';

class KeyboardKey extends StatelessWidget {
  const KeyboardKey({
    Key? key,
    required this.keyboardKey,
    this.lang = 0,
  }) : super(key: key);

  final KeyboardKeys keyboardKey;

  // lang 0  - en
  // lang 1  - ru
  final int lang;

  @override
  Widget build(BuildContext context) {
    final mainCubit = BlocProvider.of<MainCubit>(context);
    return BlocBuilder<MainCubit, MainState>(
      buildWhen: (_, currentState) {
        if (currentState is KeyboardKeyUpdateState) {
          final KeyboardKeyUpdateState state = currentState;
          if (state.keyboardKey == keyboardKey) {
            return true;
          }
        }
        return false;
      },
      builder: (context, state) {
        final dictionary = DictionaryData.getInstance();
        final width = MediaQuery.of(context).size.width > 500
            ? 500
            : MediaQuery.of(context).size.width;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: _getWidthByLang(width),
          child: AspectRatio(
            aspectRatio: lang == 0 ? 2 / 3 : 2 / 3.5,
            child: InkWell(
              onTap: () async {
                mainCubit.setLetter(keyboardKey);
                await dictionary.saveBoardToPrefs();
              },
              child: BlocBuilder<SettingsCubit, SettingsState>(
                buildWhen: (previous, current) =>
                    previous.isHighContrast != current.isHighContrast,
                builder: (context, state) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: dictionary
                          .getKeyStatus(keyboardKey.name(lang: lang))
                          .color(context, highContrast: state.isHighContrast),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      keyboardKey.name(lang: lang)?.toUpperCase() ?? "",
                      style: AppTextStyles.n14,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  double _getWidthByLang(final num width) {
    switch (lang) {
      case 0:
        return width * 0.075;
      case 1:
        return width * 0.067;
      default:
        return 0;
    }
  }
}

class EnterKeyboardKey extends StatelessWidget {
  const EnterKeyboardKey({
    Key? key,
    this.lang = 0,
  }) : super(key: key);

  final int lang;

  @override
  Widget build(BuildContext context) {
    final mainCubit = BlocProvider.of<MainCubit>(context);
    final dictionary = DictionaryData.getInstance();
    final width = MediaQuery.of(context).size.width > 500
        ? 500
        : MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(right: 2),
      height: _getHeightByLang(width),
      child: InkWell(
        onTap: () async {
          if (mainCubit.submitWord()) {
            dictionary.getAllLettersInList().asMap().map(
              (index, e) {
                final key = KeyboardKeys.values.firstWhere(
                  (element) => element.name(lang: lang) == e,
                );
                if (dictionary.secretWord[index] == e) {
                  mainCubit.updateKey(key, LetterStatus.correctSpot);
                  return MapEntry(index, e);
                }
                if (dictionary.secretWord.contains(e)) {
                  mainCubit.updateKey(key, LetterStatus.wrongSpot);
                  return MapEntry(index, e);
                }
                mainCubit.updateKey(key, LetterStatus.notInWords);
                return MapEntry(index, e);
              },
            );
            await dictionary.saveWordIndexToPrefs();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            KeyboardKeys.enter.name(lang: lang)!.toUpperCase(),
            style: AppTextStyles.n14,
          ),
        ),
      ),
    );
  }

  double _getHeightByLang(final num width) {
    switch (lang) {
      case 0:
        return width * 0.075 / 2 * 3;
      case 1:
        return width * 0.067 / 2 * 3.5;
      default:
        return 0;
    }
  }
}

class DeleteKeyboardKey extends StatelessWidget {
  const DeleteKeyboardKey({Key? key, this.lang = 0}) : super(key: key);

  final int lang;

  @override
  Widget build(BuildContext context) {
    final dictionary = DictionaryData.getInstance();
    final mainCubit = BlocProvider.of<MainCubit>(context);
    final width = MediaQuery.of(context).size.width > 500
        ? 500
        : MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(left: 2),
      width: _getWidthByLang(width),
      height: _getWidthByLang(width),
      child: InkWell(
        onTap: () async {
          mainCubit.removeLetter();
          await dictionary.saveBoardToPrefs();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.backspace_outlined),
        ),
      ),
    );
  }

  double _getWidthByLang(final num width) {
    switch (lang) {
      case 0:
        return width * 0.075 / 2 * 3;
      case 1:
        return width * 0.067 / 2 * 3.5;
      default:
        return 0;
    }
  }
}
