import 'package:material_ui/material_ui.dart';
import 'package:wordly/src/feature/game/widget/game_page.dart';
import 'package:wordly/src/feature/settings/model/general.dart';
import 'package:wordly/src/feature/settings/widget/settings_builder.dart';
import 'package:wordly/src/localization/localization.dart';
import 'package:wordly/src/localization/localization_context.dart';
import 'package:wordly/src/ui_kit/colors.dart';
import 'package:wordly/src/ui_kit/generated/fonts.gen.dart';
import 'package:wordly/src/ui_kit/theme_extensions.dart';

class const MaterialContext({super.key}) extends StatelessWidget {
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
          builder: (context, child) => MediaQuery.withClampedTextScaling(maxScaleFactor: 2, child: child!),
        );
      },
    );
  }
}
