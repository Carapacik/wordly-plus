import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/game/bloc/game_bloc.dart';
import 'package:wordly/src/feature/settings/settings.dart';

class const BlocScope({required final Widget child, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Locale dictionary = SettingsScope.of(context).settingsService.current.dictionary;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GameBloc(
            gameRepository: context.dependencies.gameRepository,
            statisticsRepository: context.dependencies.statisticsRepository,
            levelRepository: context.dependencies.levelRepository,
            dictionary: dictionary,
            savedResult: context.dependencies.gameRepository.savedResult,
          ),
        ),
      ],
      child: child,
    );
  }
}
