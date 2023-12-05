import 'package:flutter/material.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/core/constant/generated/fonts.gen.dart';
import 'package:wordly/src/core/constant/localization/localization.dart';
import 'package:wordly/src/core/resources/resources.dart';
import 'package:wordly/src/feature/app/widget/media_query_override.dart';
import 'package:wordly/src/feature/game/widget/game_page.dart';
import 'package:wordly/src/feature/settings/settings.dart';

/// Entry point for the application that uses [MaterialApp].
class const MaterialContext({super.key}) extends StatefulWidget {
  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState() extends State<MaterialContext> {
  /// This global key is needed for Flutter to work properly
  /// when Widgets Inspector is enabled.
  static final GlobalKey<State<StatefulWidget>> _globalKey = GlobalKey(debugLabel: 'MaterialContext');

  @override
  Widget build(BuildContext context) {
    return SettingsBuilder(
      builder: (context, settings) {
        final ThemeModeVO themeMode = settings.general.themeMode;
        final ColorMode colorMode = settings.general.colorMode;
        final (Color, Color, Color)? otherColors = settings.general.otherColors;
        final Locale locale = settings.general.locale;

        final ThemeMode materialThemeMode = themeMode.toMaterialThemeMode();

        final darkTheme = ThemeData(
          brightness: Brightness.dark,
          extensions: const [BackgroundCustomColors(background: AppColors.darkBackground)],
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.darkBackground,
            surfaceTintColor: AppColors.darkBackground,
          ),
          colorSchemeSeed: colorMode == ColorMode.other ? otherColors?.$1 ?? AppColors.green : AppColors.green,
          fontFamily: FontFamily.nunito,
        );
        final lightTheme = ThemeData(
          brightness: Brightness.light,
          extensions: const [BackgroundCustomColors(background: Colors.white)],
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white, surfaceTintColor: Colors.white),
          colorSchemeSeed: colorMode == ColorMode.other ? otherColors?.$1 ?? AppColors.green : AppColors.green,
          fontFamily: FontFamily.nunito,
        );
        return MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: materialThemeMode,
          localizationsDelegates: Localization.localizationDelegates,
          supportedLocales: Localization.supportedLocales,
          locale: locale,
          onGenerateTitle: (context) => context.l10n.appTitle,
          debugShowCheckedModeBanner: false,
          home: const GamePage(),
          builder: (context, child) => KeyedSubtree(
            key: _globalKey,
            child: MediaQueryRootOverride(child: child!),
          ),
        );
      },
    );
  }
}
