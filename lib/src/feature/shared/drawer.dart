import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/about/widget/about_page.dart';
import 'package:wordly/src/feature/game/bloc/game_bloc.dart';
import 'package:wordly/src/feature/game/domain/model/game_mode.dart';
import 'package:wordly/src/feature/game/widget/game_page.dart';
import 'package:wordly/src/feature/settings/settings.dart';
import 'package:wordly/src/feature/tutorial/widget/tutorial_page.dart';

class const CustomDrawer({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      backgroundColor: context.theme.extension<BackgroundCustomColors>()?.background,
      children: [
        ListTile(
          title: Text(context.l10n.daily, style: const TextStyle(fontWeight: FontWeight.w500)),
          onTap: () async {
            Scaffold.of(context).closeDrawer();
            final NavigatorState navigator = Navigator.of(context);
            final GameBloc bloc = context.read<GameBloc>()..add(const GameEvent.changeGameMode(GameMode.daily));
            await Future<void>.delayed(const Duration(milliseconds: 250));
            await navigator.pushAndRemoveUntil(
              PageRouteBuilder<void>(
                pageBuilder: (context, _, _) => BlocProvider.value(value: bloc, child: const GamePage()),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
              (route) => false,
            );
          },
        ),
        ListTile(
          title: Text(context.l10n.levels, style: const TextStyle(fontWeight: FontWeight.w500)),
          onTap: () async {
            Scaffold.of(context).closeDrawer();
            final NavigatorState navigator = Navigator.of(context);
            final GameBloc bloc = context.read<GameBloc>()..add(const GameEvent.changeGameMode(GameMode.lvl));
            await Future<void>.delayed(const Duration(milliseconds: 250));
            await navigator.pushAndRemoveUntil(
              PageRouteBuilder<void>(
                pageBuilder: (context, _, _) => BlocProvider.value(value: bloc, child: const GamePage()),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
              (route) => false,
            );
          },
        ),
        ListTile(
          title: Text(context.l10n.tutorial, style: const TextStyle(fontWeight: FontWeight.w500)),
          onTap: () async {
            Scaffold.of(context).closeDrawer();
            final NavigatorState navigator = Navigator.of(context);
            await navigator.push(
              MaterialPageRoute<void>(builder: (context) => const TutorialPage(), fullscreenDialog: true),
            );
          },
        ),
        ListTile(
          title: Text(context.l10n.settings, style: const TextStyle(fontWeight: FontWeight.w500)),
          onTap: () async {
            Scaffold.of(context).closeDrawer();
            final NavigatorState navigator = Navigator.of(context);
            final GameBloc bloc = context.read<GameBloc>();
            await navigator.push(
              MaterialPageRoute<void>(
                builder: (context) => BlocProvider.value(value: bloc, child: const SettingsPage()),
              ),
            );
          },
        ),
        ListTile(
          title: Text(context.l10n.about, style: const TextStyle(fontWeight: FontWeight.w500)),
          onTap: () async {
            Scaffold.of(context).closeDrawer();
            final NavigatorState navigator = Navigator.of(context);
            await navigator.push(
              MaterialPageRoute<void>(builder: (context) => const AboutPage(), fullscreenDialog: true),
            );
          },
        ),
      ],
    );
  }
}
