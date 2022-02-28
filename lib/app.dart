import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wordly/bloc/settings/settings_cubit.dart';
import 'package:wordly/presentation/pages/main/main_page.dart';
import 'package:wordly/resources/resources.dart';
import 'package:wordly/utils/utils.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) => MaterialApp(
          onGenerateTitle: (context) => R.stringsOf(context).wordly_plus,
          debugShowCheckedModeBanner: false,
          supportedLocales: RStringsDelegate.supportedLocales,
          localizationsDelegates: const [
            RStringsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: state.localeLanguage.locale,
          theme: state.isDark
              ? AppTheme.darkTheme.theme
              : AppTheme.lightTheme.theme,
          home: const MainPage(),
        ),
      );
}
