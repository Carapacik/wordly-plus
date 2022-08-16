import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wordly/bloc/locale/locale_bloc.dart';
import 'package:wordly/bloc/theme/theme_bloc.dart';
import 'package:wordly/data/repositories.dart';
import 'package:wordly/presentation/pages/game/game_page.dart';
import 'package:wordly/presentation/pages/tutorial/tutorial_page.dart';
import 'package:wordly/resources/resources.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final isSecondLaunch =
        context.read<ISaveSettingsRepository>().isSecondLaunch;
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) => BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, localeState) => MaterialApp(
          locale: localeState.locale.locale,
          theme: themeState.isDarkTheme ? darkTheme : lightTheme,
          localizationsDelegates: const [
            R.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: R.delegate.supportedLocales,
          onGenerateTitle: (context) => context.r.wordly_plus,
          debugShowCheckedModeBanner: false,
          home: isSecondLaunch ? const GamePage() : const TutorialPage(),
        ),
      ),
    );
  }
}
