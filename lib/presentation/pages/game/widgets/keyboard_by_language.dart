import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/bloc/dictionary/dictionary_bloc.dart';
import 'package:wordly/bloc/game/game_bloc.dart';
import 'package:wordly/data/models.dart';
import 'package:wordly/presentation/pages/game/widgets/keyboard_en.dart';
import 'package:wordly/presentation/pages/game/widgets/keyboard_ru.dart';

class KeyboardByLanguage extends StatelessWidget {
  const KeyboardByLanguage({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<DictionaryBloc, DictionaryState>(
        listener: (context, state) {
          context.read<GameBloc>().add(
                GameEvent.changeDictionary(state.dictionary),
              );
        },
        builder: (context, state) {
          switch (state.dictionary) {
            case DictionaryEnum.ru:
              return const KeyboardRu();
            case DictionaryEnum.en:
              return const KeyboardEn();
          }
        },
      );
}
