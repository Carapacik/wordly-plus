import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:wordly/app/app.dart';
import 'package:wordly/app/observer.dart';
import 'package:wordly/bloc/dictionary/dictionary_bloc.dart';
import 'package:wordly/bloc/game/game_bloc.dart';
import 'package:wordly/bloc/locale/locale_bloc.dart';
import 'package:wordly/bloc/theme/theme_bloc.dart';
import 'package:wordly/data/repositories.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  setPathUrlStrategy();

  runZonedGuarded<void>(
    () async {
      Bloc.observer = const AppBlocObserver();
      final ISaveGameRepository gameRepo = SaveGameRepository();
      final ISaveStatisticRepository statisticRepo = SaveStatisticRepository();
      final ISaveLevelsRepository levelsRepo = SaveLevelsRepository();
      final ISaveSettingsRepository settingsRepo = SaveSettingsRepository();

      await settingsRepo.init();
      final isDarkTheme = await settingsRepo.getDark();
      final isHighContrast = await settingsRepo.getHighContrast();
      final dictionary = await settingsRepo.getDictionary();
      final locale = await settingsRepo.getLocale();

      runApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<ISaveGameRepository>(
              create: (context) => gameRepo,
            ),
            RepositoryProvider<ISaveStatisticRepository>(
              create: (context) => statisticRepo,
            ),
            RepositoryProvider<ISaveLevelsRepository>(
              create: (context) => levelsRepo,
            ),
            RepositoryProvider<ISaveSettingsRepository>(
              create: (context) => settingsRepo,
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ThemeBloc>(
                create: (_) => ThemeBloc(
                  settingsRepository: settingsRepo,
                  isDarkTheme: isDarkTheme,
                  isHighContrast: isHighContrast,
                ),
              ),
              BlocProvider<DictionaryBloc>(
                create: (_) => DictionaryBloc(
                  settingsRepository: settingsRepo,
                  dictionary: dictionary,
                ),
              ),
              BlocProvider<LocaleBloc>(
                create: (_) => LocaleBloc(
                  settingsRepository: settingsRepo,
                  locale: locale,
                ),
              ),
              BlocProvider<GameBloc>(
                create: (_) => GameBloc(
                  gameRepository: gameRepo,
                  statisticRepository: statisticRepo,
                  levelsRepository: levelsRepo,
                  dictionary: dictionary,
                )..add(const GameEvent.loadGame()),
              ),
            ],
            child: const App(),
          ),
        ),
      );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
