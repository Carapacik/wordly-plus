import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wordle/bloc/settings/settings_cubit.dart';
import 'package:wordle/resources/app_themes.dart';
import 'package:wordle/resources/r.dart';
import 'package:wordle/utils/platform.dart';
import 'package:wordle/utils/utils.dart';

class AdaptiveApp extends StatelessWidget {
  const AdaptiveApp({
    Key? key,
    required this.home,
  }) : super(key: key);

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (PlatformType.isCupertino()) {
          return CupertinoApp(
            debugShowCheckedModeBanner: false,
            supportedLocales: RStringsDelegate.supportedLocales,
            localizationsDelegates: const [
              RStringsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: getLocaleFromString(state.language),
            // theme: state.isDarkThemeOn
            //     ? themes[AppTheme.darkTheme]
            //     : themes[AppTheme.lightTheme],
            home: home,
          );
        } else if (PlatformType.isFluent()) {
          return FluentApp(
            debugShowCheckedModeBanner: false,
            supportedLocales: RStringsDelegate.supportedLocales,
            localizationsDelegates: const [
              RStringsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: getLocaleFromString(state.language),
            // theme: state.isDarkThemeOn
            //     ? themes[AppTheme.darkTheme]
            //     : themes[AppTheme.lightTheme],
            home: home,
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          supportedLocales: RStringsDelegate.supportedLocales,
          localizationsDelegates: const [
            RStringsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: getLocaleFromString(state.language),
          theme: state.isDarkThemeOn
              ? themes[AppTheme.darkTheme]
              : themes[AppTheme.lightTheme],
          home: home,
        );
      },
    );
  }
}
