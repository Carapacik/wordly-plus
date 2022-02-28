import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wordly/bloc/main/main_cubit.dart';
import 'package:wordly/bloc/settings/settings_cubit.dart';
import 'package:wordly/data/models/dictionary_languages.dart';
import 'package:wordly/data/models/keyboard_keys.dart';
import 'package:wordly/data/models/letter_status.dart';
import 'package:wordly/data/repositories/dictionary_repository.dart';
import 'package:wordly/resources/resources.dart';

class KeyboardKey extends StatelessWidget {
  const KeyboardKey({
    required this.keyboardKey,
    this.lang = DictionaryLanguages.en,
    super.key,
  });

  final KeyboardKeys keyboardKey;
  final DictionaryLanguages lang;

  @override
  Widget build(BuildContext context) {
    final mainCubit = context.read<MainCubit>();
    return BlocBuilder<MainCubit, MainState>(
      buildWhen: (_, currentState) {
        if (currentState is GridUpdateState) {
          return true;
        }
        if (currentState is MainInitial) {
          return true;
        }
        if (currentState is KeyboardKeyUpdateState) {
          final state = currentState;
          if (state.keyboardKey == keyboardKey) {
            return true;
          }
        }
        return false;
      },
      builder: (context, state) {
        final dictionaryRepository = GetIt.I<DictionaryRepository>();
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: keyboardKey.width(
            language: lang,
            screenWidth: MediaQuery.of(context).size.width,
          ),
          child: AspectRatio(
            aspectRatio: lang.aspectRatio,
            child: InkWell(
              onTap: () {
                mainCubit.setLetter(keyboardKey);
              },
              child: BlocBuilder<SettingsCubit, SettingsState>(
                buildWhen: (previous, current) =>
                    previous.isHighContrast != current.isHighContrast,
                builder: (context, state) {
                  final keyStatus = dictionaryRepository
                      .getKeyStatus(keyboardKey.fromDictionaryLang(lang));
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: keyStatus.color(
                        context,
                        highContrast: state.isHighContrast,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      keyboardKey.fromDictionaryLang(lang)?.toUpperCase() ?? '',
                      style: AppTypography.r14.copyWith(
                        color: keyStatus == LetterStatus.wrongSpot
                            ? Colors.black
                            : null,
                      ),
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
}

class EnterKeyboardKey extends StatelessWidget {
  const EnterKeyboardKey({this.lang = DictionaryLanguages.en, super.key});

  final DictionaryLanguages lang;

  @override
  Widget build(BuildContext context) {
    final dictionaryRepository = GetIt.I<DictionaryRepository>();
    final mainCubit = context.read<MainCubit>();
    return Container(
      margin: const EdgeInsets.only(right: 2),
      height: KeyboardKeys.enter.width(
        language: lang,
        screenWidth: MediaQuery.of(context).size.width,
      ),
      child: InkWell(
        onTap: () {
          final wordComplete = mainCubit.completeWord();
          if (wordComplete) {
            dictionaryRepository.getAllLettersInList().map(
              (index, value) {
                final key = KeyboardKeys.values.firstWhere(
                  (element) => element.fromDictionaryLang(lang) == value,
                );
                if (dictionaryRepository.secretWord[index] == value) {
                  mainCubit.updateKey(key, LetterStatus.correctSpot);
                  return MapEntry(index, value);
                }
                if (dictionaryRepository.secretWord.contains(value)) {
                  mainCubit.updateKey(key, LetterStatus.wrongSpot);
                  return MapEntry(index, value);
                }
                mainCubit.updateKey(key, LetterStatus.notInWords);
                return MapEntry(index, value);
              },
            );
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
            KeyboardKeys.enter.fromDictionaryLang(lang)!.toUpperCase(),
            style: AppTypography.r14,
          ),
        ),
      ),
    );
  }
}

class DeleteKeyboardKey extends StatelessWidget {
  const DeleteKeyboardKey({
    this.lang = DictionaryLanguages.en,
    super.key,
  });

  final DictionaryLanguages lang;

  @override
  Widget build(BuildContext context) {
    final mainCubit = context.read<MainCubit>();
    return Container(
      margin: const EdgeInsets.only(left: 2),
      width: KeyboardKeys.delete.width(
        language: lang,
        screenWidth: MediaQuery.of(context).size.width,
      ),
      height: KeyboardKeys.delete.width(
        language: lang,
        screenWidth: MediaQuery.of(context).size.width,
      ),
      child: InkWell(
        onTap: mainCubit.removeLetter,
        onLongPress: mainCubit.removeFullWord,
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
}
