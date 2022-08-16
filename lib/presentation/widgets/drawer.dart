import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/bloc/game/game_bloc.dart';
import 'package:wordly/presentation/pages/credits/credits_page.dart';
import 'package:wordly/presentation/pages/game/game_page.dart';
import 'package:wordly/presentation/pages/settings/settings_page.dart';
import 'package:wordly/presentation/pages/tutorial/tutorial_page.dart';
import 'package:wordly/resources/resources.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: context.theme.scaffoldBackgroundColor),
        width: 200,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(context.r.daily, style: context.theme.tmb),
                onTap: () async {
                  context.read<GameBloc>().add(
                        const GameEvent.loadGame(),
                      );
                  await Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (context) => const GamePage(),
                    ),
                    (route) => false,
                  );
                },
              ),
              ListTile(
                title: Text(context.r.levels, style: context.theme.tmb),
                onTap: () async {
                  context.read<GameBloc>().add(
                        const GameEvent.loadGame(isDaily: false),
                      );
                  await Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (context) => const GamePage(isDailyMode: false),
                    ),
                    (route) => false,
                  );
                },
              ),
              ListTile(
                title: Text(context.r.how_to_play, style: context.theme.tmb),
                onTap: () async {
                  final navigator = Navigator.of(context)..pop();
                  await navigator.push(
                    MaterialPageRoute<void>(
                      builder: (context) => const TutorialPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(context.r.settings, style: context.theme.tmb),
                onTap: () async {
                  final navigator = Navigator.of(context)..pop();
                  await navigator.push(
                    MaterialPageRoute<void>(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
              const Spacer(),
              ListTile(
                title: Text(context.r.about, style: context.theme.tmb),
                onTap: () async {
                  final navigator = Navigator.of(context)..pop();
                  await navigator.push(
                    MaterialPageRoute<void>(
                      builder: (context) => const CreditsPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
}
