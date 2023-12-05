import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/core/constant/localization/localization.dart';
import 'package:wordly/src/feature/game/bloc/game_bloc.dart';
import 'package:wordly/src/feature/settings/settings.dart';
import 'package:wordly/src/feature/shared/constraint_screen.dart';

class const SettingsPage({super.key}) extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState() extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SettingsBuilder(
      builder: (context, settings) {
        final SettingsContainer settingsScope = SettingsScope.of(context);
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
              child: Column(
                children: [
                  ListItemSelector<Locale>(
                    title: context.l10n.appDictionary,
                    currentValue: (settings.dictionary, _localeName(settings.dictionary, withDictionary: true)),
                    items: Localization.supportedDictionaryLocales
                        .map((e) => (e, _localeName(e, withDictionary: true)))
                        .toList(growable: false),
                    onChange: (d) async {
                      await settingsScope.settingsService.update((current) => current.copyWith(dictionary: d));
                      gameBloc.add(GameEvent.changeDictionary(d));
                    },
                  ),
                  ListItemSelector<Locale>(
                    title: context.l10n.appLanguage,
                    currentValue: (
                      settings.general.locale,
                      _localeName(settings.general.locale, withDictionary: false),
                    ),
                    items: Localization.supportedLocales
                        .map((e) => (e, _localeName(e, withDictionary: false)))
                        .toList(growable: false),
                    onChange: (l) async {
                      await settingsScope.settingsService.update(
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
                      await settingsScope.settingsService.update(
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
                          final ChangeColorResult? result = await navigator.push(
                            MaterialPageRoute<ChangeColorResult>(
                              builder: (context) => ChangeColorPage(
                                dictionary: settings.dictionary,
                                previousResult: ChangeColorResult(
                                  colorMode: settings.general.colorMode,
                                  otherColors: settings.general.otherColors,
                                ),
                              ),
                            ),
                          );
                          if (result == null) {
                            return;
                          }
                          await settingsScope.settingsService.update(
                            (current) => current.copyWith(
                              general: current.general.copyWith(
                                colorMode: result.colorMode,
                                otherColors: result.otherColors,
                              ),
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

  String _localeName(Locale? locale, {required bool withDictionary}) {
    final Map<String, String> locales = {'en': context.l10n.en, 'ru': context.l10n.ru};
    return locales[(locale ?? Localization.computeDefaultLocale(withDictionary: withDictionary)).languageCode] ??
        context.l10n.en;
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
