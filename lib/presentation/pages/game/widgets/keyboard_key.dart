import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/bloc/game/game_bloc.dart';
import 'package:wordly/data/models.dart';
import 'package:wordly/resources/resources.dart';

class KeyboardKey extends StatelessWidget {
  const KeyboardKey({
    required this.keyboardKey,
    this.dictionary = DictionaryEnum.en,
    super.key,
  });

  final KeyboardKeys keyboardKey;
  final DictionaryEnum dictionary;

  @override
  Widget build(BuildContext context) {
    final sizeUnit = keyboardKey.sizeUnit(context, dictionary);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: sizeUnit * 3,
      width: sizeUnit * 2,
      child: BlocBuilder<GameBloc, GameState>(
        buildWhen: (_, current) => current.isSubmit,
        builder: (context, state) => Material(
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(6),
          color: _bgColorByState(state, context),
          child: InkWell(
            onTap: () {
              context.read<GameBloc>().add(
                    GameEvent.letterPressed(keyboardKey),
                  );
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.center,
              child: FittedBox(
                child: Text(
                  keyboardKey.fromDictionary(dictionary)?.toUpperCase() ?? '',
                  style: context.theme.ll.copyWith(
                    color: _txtColorByState(state, context),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _bgColorByState(GameState state, BuildContext context) {
    final color = state.mapOrNull(
      wordSubmit: (s) {
        if (s.keyboard.containsKey(keyboardKey)) {
          return s.keyboard[keyboardKey]?.itemColor(context, grid: false);
        }
        return null;
      },
    );
    return color ??
        context.dynamicColor(
          light: AppColors.lightGrey,
          dark: AppColors.darkGrey,
        );
  }

  Color _txtColorByState(GameState state, BuildContext context) {
    final color = state.mapOrNull(
      wordSubmit: (s) {
        if (s.keyboard.containsKey(keyboardKey)) {
          return s.keyboard[keyboardKey] != LetterStatus.unknown
              ? Colors.white
              : null;
        }
        return context.dynamicColor(
          light: AppColors.dark,
          dark: AppColors.light,
        );
      },
    );
    return color ??
        context.dynamicColor(
          light: AppColors.dark,
          dark: AppColors.light,
        );
  }
}

class EnterKeyboardKey extends StatelessWidget {
  const EnterKeyboardKey({this.dictionary = DictionaryEnum.en, super.key});

  final DictionaryEnum dictionary;

  @override
  Widget build(BuildContext context) {
    final sizeUnit = KeyboardKeys.enter.sizeUnit(context, dictionary);
    return Container(
      margin: const EdgeInsets.only(right: 2),
      height: sizeUnit * 3,
      width: sizeUnit * 3.5,
      child: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(6),
        color: context.dynamicColor(
          light: AppColors.lightGrey,
          dark: AppColors.darkGrey,
        ),
        child: InkWell(
          onTap: () {
            context.read<GameBloc>().add(const GameEvent.enterPressed());
          },
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.center,
            child: FittedBox(
              child: Text(
                KeyboardKeys.enter.fromDictionary(dictionary)!.toUpperCase(),
                style: context.theme.ll,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DeleteKeyboardKey extends StatelessWidget {
  const DeleteKeyboardKey({this.dictionary = DictionaryEnum.en, super.key});

  final DictionaryEnum dictionary;

  @override
  Widget build(BuildContext context) {
    final sizeUnit = KeyboardKeys.delete.sizeUnit(context, dictionary);
    return Container(
      margin: const EdgeInsets.only(left: 2),
      height: sizeUnit * 3,
      width: sizeUnit * 3,
      child: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(6),
        color: context.dynamicColor(
          light: AppColors.lightGrey,
          dark: AppColors.darkGrey,
        ),
        child: InkWell(
          onTap: () {
            context.read<GameBloc>().add(const GameEvent.deletePressed());
          },
          onLongPress: () {
            context.read<GameBloc>().add(const GameEvent.deleteLongPressed());
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.center,
            child: FittedBox(
              child: Icon(
                Icons.backspace_outlined,
                color: context.dynamicColor(
                  light: AppColors.dark,
                  dark: AppColors.light,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
