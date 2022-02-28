import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle/bloc/main/main_cubit.dart';
import 'package:wordle/data/dictionary_data.dart';
import 'package:wordle/data/models/flushbar_types.dart';
import 'package:wordle/presentation/pages/main/widgets/keyboard_en.dart';
import 'package:wordle/presentation/pages/main/widgets/keyboard_ru.dart';
import 'package:wordle/presentation/pages/main/widgets/word_grid.dart';
import 'package:wordle/presentation/widgets/adaptive_scaffold.dart';
import 'package:wordle/presentation/widgets/dialogs/top_flush_bar.dart';
import 'package:wordle/resources/r.dart';
import 'package:wordle/utils/utils.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      showDialogIfNeed(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _dictionary = DictionaryData.getInstance();
    return BlocProvider<MainCubit>(
      create: (BuildContext context) =>
          MainCubit(_dictionary.dictionaryLanguage),
      child: AdaptiveScaffold(
        child: Center(
          child: BlocConsumer<MainCubit, MainState>(
            listener: (context, state) {
              if (state is TopMessageState) {
                switch (state.type) {
                  case FlushBarTypes.notFound:
                    showTopFlushBar(
                      context,
                      message: R.stringsOf(context).word_not_found,
                    );
                    break;
                  case FlushBarTypes.notCorrectLength:
                    showTopFlushBar(
                      context,
                      message: R.stringsOf(context).word_too_short,
                    );
                    break;
                }
              } else if (state is WinGameState) {
                showDialogIfNeed(context, isWin: true);
              } else if (state is LoseGameState) {
                showDialogIfNeed(context, isWin: false);
              }
            },
            buildWhen: (_, currState) => currState is ChangeDictionaryState,
            builder: (context, state) {
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: FutureBuilder(
                  future: _dictionary.getBoard(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        key: UniqueKey(),
                        children: [
                          const SizedBox(height: 16),
                          const WordGrid(),
                          const Spacer(),
                          const SizedBox(height: 16),
                          BlocBuilder<MainCubit, MainState>(
                            buildWhen: (previous, current) =>
                                current is ChangeDictionaryState,
                            builder: (context, state) => _getKeyboardByLanguage(
                              state is! ChangeDictionaryState
                                  ? DictionaryData.getInstance()
                                      .dictionaryLanguage
                                  : state.dictionary,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    } else {
                      //TODO: probably will stay the same with splashscreen ending on future loaded
                      return const SizedBox.shrink();
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _getKeyboardByLanguage(final String language) {
    switch (language) {
      case "ru":
        return const KeyboardRu();
      case "en":
      default:
        return const KeyboardEn();
    }
  }
}
