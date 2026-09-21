import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wordly/src/feature/app/widget/dependencies_context.dart';
import 'package:wordly/src/feature/game/logic/game_bloc.dart';
import 'package:wordly/src/feature/settings/widget/settings_scope.dart';

class const BlocScope({required final Widget child, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SettingsScopeState settingsScope = SettingsScope.of(context);
    final Locale dictionary = settingsScope.settings.dictionary;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GameBloc(
            gameRepository: context.dependencies.gameRepository,
            levelRepository: context.dependencies.levelRepository,
            dictionary: dictionary,
            isHardMode: () => settingsScope.settings.hardMode,
            savedResult: context.dependencies.gameRepository.savedResult,
          ),
        ),
      ],
      child: child,
    );
  }
}
