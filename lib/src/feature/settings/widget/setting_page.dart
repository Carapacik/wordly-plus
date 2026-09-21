import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wordly/src/feature/game/logic/game_bloc.dart';
import 'package:wordly/src/feature/settings/model/general.dart';
import 'package:wordly/src/feature/settings/widget/change_color_page.dart';
import 'package:wordly/src/feature/settings/widget/settings_builder.dart';
import 'package:wordly/src/feature/settings/widget/settings_save_error.dart';
import 'package:wordly/src/feature/settings/widget/settings_scope.dart';
import 'package:wordly/src/localization/localization.dart';
import 'package:wordly/src/localization/localization_context.dart';
import 'package:wordly/src/ui_kit/controls/list_item_selector.dart';
import 'package:wordly/src/ui_kit/layout/constraint_screen.dart';
import 'package:wordly/src/ui_kit/theme_context.dart';
import 'package:wordly/src/ui_kit/theme_extensions.dart';

class const SettingsPage({super.key}) extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState() extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SettingsBuilder(
      builder: (context, settings) {
        final SettingsScopeState settingsScope = SettingsScope.of(context);
        final GameBloc gameBloc = context.read<GameBloc>();
        return Title(
          color: Colors.black,
          title: context.l10n.settings,
          child: Scaffold(
            backgroundColor: context.theme.extension<BackgroundCustomColors>()?.background,
            appBar: AppBar(
              centerTitle: true,
              title: Text(context.l10n.settings, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 32)),
            ),
            body: ConstraintScreen(
              child: ListView(
                children: [
                  const SettingsSaveError(),
                  SwitchListTile.adaptive(
                    title: Text(context.l10n.hardMode),
                    subtitle: Text(context.l10n.hardModeDescription),
                    value: settings.hardMode,
                    onChanged: (value) async {
                      await settingsScope.update((current) => current.copyWith(hardMode: value));
                    },
                  ),
                  ListItemSelector<Locale>(
                    title: context.l10n.appDictionary,
                    currentValue: (settings.dictionary, _localeName(settings.dictionary)),
                    items: Localization.supportedDictionaryLocales
                        .map((e) => (e, _localeName(e)))
                        .toList(growable: false),
                    onChange: (d) async {
                      if (gameBloc.state.isPersistenceFailure) {
                        return;
                      }
                      if (await settingsScope.update((current) => current.copyWith(dictionary: d))) {
                        gameBloc.add(GameEvent.changeDictionary(d));
                      }
                    },
                  ),
                  ListItemSelector<Locale>(
                    title: context.l10n.appLanguage,
                    currentValue: (settings.general.locale, _localeName(settings.general.locale)),
                    items: Localization.supportedLocales.map((e) => (e, _localeName(e))).toList(growable: false),
                    onChange: (l) async {
                      await settingsScope.update(
                        (current) => current.copyWith(general: current.general.copyWith(locale: l)),
                      );
                    },
                  ),
                  ListItemSelector<ThemeModeVO>(
                    title: context.l10n.themeMode,
                    currentValue: (settings.general.themeMode, _themeName(settings.general.themeMode)),
                    items: [
                      (ThemeModeVO.system, context.l10n.themeSystem),
                      (ThemeModeVO.dark, context.l10n.themeDark),
                      (ThemeModeVO.light, context.l10n.themeLight),
                    ],
                    onChange: (tm) async {
                      await settingsScope.update(
                        (current) => current.copyWith(general: current.general.copyWith(themeMode: tm)),
                      );
                    },
                  ),
                  MergeSemantics(
                    child: ListTileTheme.merge(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        title: Text(
                          context.l10n.colorMode,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        trailing: Text(
                          settings.general.colorMode.localized(context),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        onTap: () async {
                          final NavigatorState navigator = Navigator.of(context);
                          await navigator.push(
                            MaterialPageRoute<void>(
                              builder: (context) =>
                                  ChangeColorPage(dictionary: settings.dictionary, initialSettings: settings.general),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _localeName(Locale locale) {
    final Map<String, String> locales = {'en': context.l10n.en, 'ru': context.l10n.ru};
    return locales[locale.languageCode] ?? context.l10n.en;
  }

  String _themeName(ThemeModeVO mode) {
    final Map<ThemeModeVO, String> themeModes = {
      ThemeModeVO.system: context.l10n.themeSystem,
      ThemeModeVO.dark: context.l10n.themeDark,
      ThemeModeVO.light: context.l10n.themeLight,
    };
    return themeModes[mode] ?? context.l10n.themeSystem;
  }
}
