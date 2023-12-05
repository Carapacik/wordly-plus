import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/src/core/constant/generated/fonts.gen.dart';
import 'package:wordly/src/feature/game/bloc/game_bloc.dart';
import 'package:wordly/src/feature/game/domain/model/keyboard.dart';
import 'package:wordly/src/feature/game/domain/model/letter_info.dart';
import 'package:wordly/src/feature/settings/settings.dart';

class const KeyboardByLanguage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsBuilder(
      builder: (context, settings) {
        final Locale dictionary = settings.dictionary;
        return SizedBox(
          height: 200,
          child: switch (dictionary.languageCode) {
            'en' => KeyboardEn(generalSettings: settings.general, dictionary: dictionary),
            'ru' => KeyboardRu(generalSettings: settings.general, dictionary: dictionary),
            _ => const SizedBox.shrink(),
          },
        );
      },
    );
  }
}

class const KeyboardEn({required final GeneralSettings generalSettings, required final Locale dictionary, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, LetterStatus> statuses = context.watch<GameBloc>().state.statuses;
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < KeyboardList.enKeyboard.$1.length; i++)
              KeyboardKey(
                letter: KeyboardList.enKeyboard.$1[i],
                status: statuses.containsKey(KeyboardList.enKeyboard.$1[i])
                    ? statuses[KeyboardList.enKeyboard.$1[i]]!
                    : LetterStatus.unknown,
                generalSettings: generalSettings,
                dictionary: dictionary,
              ),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < KeyboardList.enKeyboard.$2.length; i++)
              KeyboardKey(
                letter: KeyboardList.enKeyboard.$2[i],
                status: statuses.containsKey(KeyboardList.enKeyboard.$2[i])
                    ? statuses[KeyboardList.enKeyboard.$2[i]]!
                    : LetterStatus.unknown,
                generalSettings: generalSettings,
                dictionary: dictionary,
              ),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            EnterKey(generalSettings: generalSettings, dictionary: dictionary),
            for (var i = 0; i < KeyboardList.enKeyboard.$3.length; i++)
              KeyboardKey(
                letter: KeyboardList.enKeyboard.$3[i],
                status: statuses.containsKey(KeyboardList.enKeyboard.$3[i])
                    ? statuses[KeyboardList.enKeyboard.$3[i]]!
                    : LetterStatus.unknown,
                generalSettings: generalSettings,
                dictionary: dictionary,
              ),
            DeleteKey(generalSettings: generalSettings, dictionary: dictionary),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class const KeyboardRu({required final GeneralSettings generalSettings, required final Locale dictionary, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, LetterStatus> statuses = context.watch<GameBloc>().state.statuses;
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < KeyboardList.ruKeyboard.$1.length; i++)
              KeyboardKey(
                letter: KeyboardList.ruKeyboard.$1[i],
                status: statuses.containsKey(KeyboardList.ruKeyboard.$1[i])
                    ? statuses[KeyboardList.ruKeyboard.$1[i]]!
                    : LetterStatus.unknown,
                generalSettings: generalSettings,
                dictionary: dictionary,
              ),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < KeyboardList.ruKeyboard.$2.length; i++)
              KeyboardKey(
                letter: KeyboardList.ruKeyboard.$2[i],
                status: statuses.containsKey(KeyboardList.ruKeyboard.$2[i])
                    ? statuses[KeyboardList.ruKeyboard.$2[i]]!
                    : LetterStatus.unknown,
                generalSettings: generalSettings,
                dictionary: dictionary,
              ),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            EnterKey(generalSettings: generalSettings, dictionary: dictionary),
            for (var i = 0; i < KeyboardList.ruKeyboard.$3.length; i++)
              KeyboardKey(
                letter: KeyboardList.ruKeyboard.$3[i],
                status: statuses.containsKey(KeyboardList.ruKeyboard.$3[i])
                    ? statuses[KeyboardList.ruKeyboard.$3[i]]!
                    : LetterStatus.unknown,
                generalSettings: generalSettings,
                dictionary: dictionary,
              ),
            DeleteKey(generalSettings: generalSettings, dictionary: dictionary),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class const EnterKey({required final GeneralSettings generalSettings, required final Locale dictionary, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 3),
      child: SizedBox(
        height: 58,
        width: dictionary.width(context) * 1.65,
        child: Material(
          color: LetterStatus.unknown.cellColor(context, generalSettings),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: InkWell(
            onTap: () => context.read<GameBloc>().add(const GameEvent.enterPressed()),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: FittedBox(
                child: Icon(Icons.send, color: LetterStatus.unknown.textColor(context, generalSettings)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class const DeleteKey({required final GeneralSettings generalSettings, required final Locale dictionary, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3),
      child: SizedBox(
        height: 58,
        width: dictionary.width(context) * 1.65,
        child: Material(
          color: LetterStatus.unknown.cellColor(context, generalSettings),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: InkWell(
            onTap: () => context.read<GameBloc>().add(const GameEvent.deletePressed()),
            onLongPress: () => context.read<GameBloc>().add(const GameEvent.deleteLongPressed()),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: FittedBox(
                child: Icon(Icons.backspace_outlined, color: LetterStatus.unknown.textColor(context, generalSettings)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class const KeyboardKey({
  required final String letter,
  required final LetterStatus status,
  required final GeneralSettings generalSettings,
  required final Locale dictionary,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: SizedBox(
        height: 58,
        width: dictionary.width(context),
        child: Material(
          color: status.cellColor(context, generalSettings),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: InkWell(
            onTap: () {
              context.read<GameBloc>().add(GameEvent.letterPressed(letter));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: FittedBox(
                child: Text(
                  letter.toUpperCase(),
                  style: TextStyle(
                    color: status.textColor(context, generalSettings),
                    fontFamily: FontFamily.robotoMono,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
