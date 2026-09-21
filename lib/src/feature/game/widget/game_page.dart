import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wordly/src/feature/app/widget/app_drawer.dart';
import 'package:wordly/src/feature/app/widget/dependencies_context.dart';
import 'package:wordly/src/feature/game/data/game_repository.dart';
import 'package:wordly/src/feature/game/logic/game_bloc.dart';
import 'package:wordly/src/feature/game/model/game_mode.dart';
import 'package:wordly/src/feature/game/model/letter_info.dart';
import 'package:wordly/src/feature/game/model/word_error.dart';
import 'package:wordly/src/feature/game/widget/game_result_dialog.dart';
import 'package:wordly/src/feature/game/widget/keyboard_by_language.dart';
import 'package:wordly/src/feature/game/widget/words_grid.dart';
import 'package:wordly/src/feature/level/widget/level_page.dart';
import 'package:wordly/src/feature/settings/model/settings.dart';
import 'package:wordly/src/feature/settings/widget/settings_builder.dart';
import 'package:wordly/src/feature/settings/widget/settings_scope.dart';
import 'package:wordly/src/feature/statistic/widget/statistic_page.dart';
import 'package:wordly/src/feature/tutorial/widget/tutorial_page.dart';
import 'package:wordly/src/localization/localization_context.dart';
import 'package:wordly/src/ui_kit/theme_context.dart';
import 'package:wordly/src/ui_kit/theme_extensions.dart';
import 'package:wordly/src/utils/share.dart';

class const GamePage({super.key}) extends StatefulWidget {
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState() extends State<GamePage> {
  late final FocusNode _focusNode;
  AppLifecycleListener? _lifecycle;
  Timer? _dayTimer;

  void _checkDaily() {
    if (!mounted) {
      return;
    }
    context.read<GameBloc>().add(const GameEvent.refreshDaily());
    _dayTimer?.cancel();
    final DateTime now = DateTime.now().toUtc();
    _dayTimer = Timer(DateTime.utc(now.year, now.month, now.day + 1).difference(now), _checkDaily);
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _lifecycle = AppLifecycleListener(onResume: _checkDaily);
    _checkDaily();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final NavigatorState navigator = Navigator.of(context);
      final IGameRepository gameRepository = context.dependencies.gameRepository;
      final GameBloc bloc = context.read<GameBloc>();
      final GameState state = bloc.state;
      if (state.isResult) {
        final String meaning = await gameRepository.definition(state.dictionary, state.secretWord);
        if (!mounted || bloc.state != state) {
          return;
        }
        unawaited(
          showGameResultDialog(
            context,
            state.secretWord,
            meaning,
            state.gameMode,
            isWin: state.isWin,
            onTimerEnd: GameMode.daily == state.gameMode ? () => bloc.add(const GameEvent.refreshDaily()) : null,
            closeWhen: _dailyDialogChanges(bloc, state),
            shareString: shareString(context, state.buildResultString),
            nextLevelPressed: () => bloc.add(const GameEvent.resetBoard(GameMode.lvl)),
          ),
        );
      }
      final bool isFirstEnter = await gameRepository.isFirstEnter;
      if (!mounted) {
        return;
      }
      if (isFirstEnter) {
        unawaited(gameRepository.setFirstEnter());
        navigator.push(MaterialPageRoute<void>(builder: (context) => const TutorialPage(), fullscreenDialog: true));
        return;
      }
    });
  }

  @override
  void dispose() {
    _dayTimer?.cancel();
    _lifecycle?.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SettingsScopeState settingsScope = SettingsScope.of(context, listen: true);
    final Settings settings = settingsScope.settings;
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          context.read<GameBloc>().add(GameEvent.listenKeyEvent(event));
        }
      },
      child: Scaffold(
        backgroundColor: context.theme.extension<BackgroundCustomColors>()?.background,
        appBar: AppBar(
          centerTitle: true,
          title: BlocBuilder<GameBloc, GameState>(
            builder: (context, state) => Text(
              state.gameMode == GameMode.daily ? context.l10n.daily : context.l10n.levelNumber(state.lvlNumber ?? 1),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
            ),
          ),
          actions: [
            BlocBuilder<GameBloc, GameState>(
              builder: (context, state) {
                if (state.gameMode == GameMode.daily) {
                  return IconButton(
                    tooltip: context.l10n.viewStatistic,
                    icon: const Icon(Icons.leaderboard_outlined),
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (context) => StatisticPage(dictionary: settings.dictionary)),
                      );
                    },
                  );
                } else {
                  return IconButton(
                    tooltip: context.l10n.viewLevels,
                    icon: const Icon(Icons.apps),
                    onPressed: () async {
                      await Navigator.of(
                        context,
                      ).push(MaterialPageRoute<void>(builder: (context) => LevelPage(dictionary: settings.dictionary)));
                    },
                  );
                }
              },
            ),
          ],
        ),
        drawer: const CustomDrawer(),
        body: const Center(child: SizedBox(width: 840, child: GameBody())),
      ),
    );
  }
}

class const GameBody({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsBuilder(
      builder: (context, settings) => BlocListener<GameBloc, GameState>(
        listenWhen: (previous, current) =>
            (!previous.gameCompleted &&
                current.gameCompleted &&
                previous.gameMode == current.gameMode &&
                previous.dictionary == current.dictionary &&
                current.isResult) ||
            current.isFailure ||
            (previous.isPersistenceFailure && !current.isPersistenceFailure),
        listener: (context, state) async {
          if (!state.isPersistenceFailure) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
          if (state.isResult) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            final GameBloc bloc = context.read<GameBloc>();
            final String meaning = await context.dependencies.gameRepository.definition(
              state.dictionary,
              state.secretWord,
            );
            if (!context.mounted || bloc.state != state) {
              return;
            }
            unawaited(
              showGameResultDialog(
                context,
                state.secretWord,
                meaning,
                state.gameMode,
                isWin: state.isWin,
                onTimerEnd: GameMode.daily == state.gameMode ? () => bloc.add(const GameEvent.refreshDaily()) : null,
                closeWhen: _dailyDialogChanges(bloc, state),
                shareString: shareString(context, state.buildResultString),
                nextLevelPressed: () {
                  Navigator.of(context).pop();
                  bloc.add(const GameEvent.resetBoard(GameMode.lvl));
                },
              ),
            );
            return;
          }
          if (state.isFailure) {
            if (state is GamePersistenceFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.operation == GamePersistenceOperation.loadDaily ||
                            state.operation == GamePersistenceOperation.loadNextLevel ||
                            state.operation == GamePersistenceOperation.loadGame
                        ? context.l10n.progressLoadFailed
                        : context.l10n.progressSaveFailed,
                  ),
                  duration: const Duration(days: 1),
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: context.l10n.retry,
                    onPressed: () => context.read<GameBloc>().add(const GameEvent.retryLevelPersistence()),
                  ),
                ),
              );
              return;
            }
            WordError? error;
            if (state case final GameFailure e) {
              error = e.error;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: LetterStatus.unknown.cellColor(context, settings.general),
                content: Text(
                  error?.localizedText(context) ?? '',
                  style: TextStyle(color: LetterStatus.unknown.textColor(context, settings.general), fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                dismissDirection: DismissDirection.up,
                width: 350,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            );
          }
        },
        child: const SafeArea(child: _GameLayout()),
      ),
    );
  }
}

class const _GameLayout() extends StatelessWidget {
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final double boardWidth = ((constraints.maxHeight - 240) / 1.2).clamp(240, 366);
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: SizedBox(width: boardWidth, child: const WordsGrid()),
                ),
                const SizedBox(height: 8),
                const Center(child: KeyboardByLanguage()),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Stream<void>? _dailyDialogChanges(GameBloc bloc, GameState shown) {
  if (shown.gameMode != GameMode.daily) {
    return null;
  }
  final DateTime date = bloc.dailyDate;
  return bloc.stream
      .where((next) => bloc.dailyDate != date || next.gameMode != shown.gameMode || next.dictionary != shown.dictionary)
      .map((_) {});
}
