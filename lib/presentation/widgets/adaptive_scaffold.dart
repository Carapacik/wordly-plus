import 'package:auth_repository/auth_repository.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as f;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle/bloc/app/app_bloc.dart';
import 'package:wordle/bloc/main/main_cubit.dart';
import 'package:wordle/presentation/pages/settings/settings_page.dart';
import 'package:wordle/presentation/pages/statistic/statistic_page.dart';
import 'package:wordle/presentation/widgets/dialogs/how_to_play.dart';
import 'package:wordle/resources/app_text_styles.dart';
import 'package:wordle/resources/r.dart';
import 'package:wordle/utils/platform.dart';
import 'package:wordle/utils/utils.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (PlatformType.isCupertino()) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(R.stringsOf(context).wordle.toUpperCase()),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: m.IconButton(
            onPressed: () async {
              await showHowToPlayDialog(context);
            },
            icon: const Icon(CupertinoIcons.question_circle_fill),
          ),
          trailing: Row(
            children: [
              m.IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      final authRepository = AuthRepository();
                      authRepository.user.first;
                      return RepositoryProvider.value(
                        value: authRepository,
                        child: BlocProvider(
                          create: (context) =>
                              AppBloc(authRepository: authRepository),
                          child: StatisticPage(
                            authRepository: authRepository,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                icon: const Icon(Icons.leaderboard),
              ),
              m.IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<SettingsPage>(
                    builder: (_) {
                      return BlocProvider.value(
                        value: BlocProvider.of<MainCubit>(context),
                        child: const SettingsPage(),
                      );
                    },
                    fullscreenDialog: true,
                  ),
                ),
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
        ),
        child: child,
      );
    } else if (PlatformType.isFluent()) {
      return NavigationView(
        appBar: NavigationAppBar(
          title: Text(R.stringsOf(context).wordle),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: f.IconButton(
            onPressed: () async {
              await showHowToPlayDialog(context);
            },
            icon: const Icon(Icons.help_outline),
          ),
          actions: Row(
            children: [
              f.IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      final authRepository = AuthRepository();
                      authRepository.user.first;
                      return RepositoryProvider.value(
                        value: authRepository,
                        child: BlocProvider(
                          create: (context) =>
                              AppBloc(authRepository: authRepository),
                          child: StatisticPage(
                            authRepository: authRepository,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                icon: const Icon(Icons.leaderboard),
              ),
              f.IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<SettingsPage>(
                    builder: (_) {
                      return BlocProvider.value(
                        value: BlocProvider.of<MainCubit>(context),
                        child: const SettingsPage(),
                      );
                    },
                    fullscreenDialog: true,
                  ),
                ),
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
        ),
        content: child,
      );
    }
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          R.stringsOf(context).wordle.toUpperCase(),
          style: AppTextStyles.b30,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).primaryColor,
        leading: m.IconButton(
          onPressed: () async {
            await showHowToPlayDialog(context);
          },
          icon: const Icon(Icons.help_outline),
        ),
        actions: [
          m.IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  final authRepository = AuthRepository();
                  authRepository.user.first;
                  return RepositoryProvider.value(
                    value: authRepository,
                    child: BlocProvider(
                      create: (context) =>
                          AppBloc(authRepository: authRepository),
                      child: StatisticPage(
                        authRepository: authRepository,
                      ),
                    ),
                  );
                },
              ),
            ),
            icon: const Icon(Icons.leaderboard),
          ),
          m.IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<SettingsPage>(
                builder: (_) {
                  return BlocProvider.value(
                    value: BlocProvider.of<MainCubit>(context),
                    child: const SettingsPage(),
                  );
                },
                fullscreenDialog: true,
              ),
            ).then((_) => showDialogIfNeed(context)),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: child,
    );
  }
}
