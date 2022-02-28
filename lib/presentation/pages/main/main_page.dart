import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wordly/bloc/main/main_cubit.dart';
import 'package:wordly/bloc/settings/settings_cubit.dart';
import 'package:wordly/data/models/flushbar_types.dart';
import 'package:wordly/domain/level_repository.dart';
import 'package:wordly/presentation/pages/levels/levels_page.dart';
import 'package:wordly/presentation/pages/main/widgets/keyboard_by_language.dart';
import 'package:wordly/presentation/pages/main/widgets/word_grid.dart';
import 'package:wordly/presentation/pages/statistic/statistic_page.dart';
import 'package:wordly/presentation/widgets/widgets.dart';
import 'package:wordly/utils/utils.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkResultDialog(context);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final levelRepository = GetIt.I<LevelRepository>();
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final mainCubit = context.read<MainCubit>();
        return RawKeyboardListener(
          autofocus: true,
          focusNode: _focusNode,
          onKey: (event) {
            if (event is RawKeyDownEvent) {
              mainCubit.keyDown(event, state.dictionaryLanguage);
              return;
            }
          },
          child: BlocConsumer<MainCubit, MainState>(
            listener: (context, state) async {
              if (state is TopMessageState) {
                switch (state.type) {
                  case SnackbarType.notFound:
                    await showSnackBar(
                      context,
                      message: R.stringsOf(context).word_not_found,
                    );
                    break;
                  case SnackbarType.notCorrectLength:
                    await showSnackBar(
                      context,
                      message: R.stringsOf(context).word_too_short,
                    );
                    break;
                }
              } else if (state is WinGameState) {
                await checkResultDialog(context, isWin: true);
              } else if (state is LoseGameState) {
                await checkResultDialog(context, isWin: false);
              }
            },
            buildWhen: (_, currentState) =>
                currentState is MainInitial || currentState is GridUpdateState,
            builder: (context, state) {
              final settingsCubit = context.read<SettingsCubit>();
              return Scaffold(
                drawer: const CustomDrawer(),
                appBar: CustomAppBar(
                  title: levelRepository.isLevelMode
                      ? R.stringsOf(context).level_number(
                            number: levelRepository.levelData.lastLevel,
                          )
                      : R.stringsOf(context).wordle.toUpperCase(),
                  actions: [
                    if (levelRepository.isLevelMode)
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (context) => const LevelsPage(),
                            ),
                          );
                        },
                        tooltip: R.stringsOf(context).view_levels,
                        icon: const Icon(Icons.apps),
                      )
                    else
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const StatisticPage(),
                            ),
                          );
                        },
                        tooltip: R.stringsOf(context).view_statistic,
                        icon: const Icon(Icons.leaderboard),
                      ),
                  ],
                ),
                body: ConstraintScreen(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      const WordsGrid(),
                      const Spacer(),
                      KeyboardByLanguage(
                        language: settingsCubit.state.dictionaryLanguage,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
