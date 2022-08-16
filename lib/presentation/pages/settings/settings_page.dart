import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/bloc/dictionary/dictionary_bloc.dart';
import 'package:wordly/bloc/locale/locale_bloc.dart';
import 'package:wordly/bloc/theme/theme_bloc.dart';
import 'package:wordly/data/models.dart';
import 'package:wordly/presentation/pages/settings/widgets/language_selector.dart';
import 'package:wordly/presentation/pages/settings/widgets/toggle_list_tile.dart';
import 'package:wordly/presentation/widgets/widgets.dart';
import 'package:wordly/resources/resources.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) => Title(
          color: AppColors.dark,
          title: context.r.settings,
          child: Scaffold(
            appBar: CustomAppBar(title: context.r.settings),
            body: ConstraintScreen(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  ToggleListTile(
                    title: context.r.dark_mode,
                    value: themeState.isDarkTheme,
                    onChanged: (value) => context.read<ThemeBloc>().add(
                          const ThemeEvent.toggleTheme(),
                        ),
                  ),
                  const _Divider(),
                  ToggleListTile(
                    title: context.r.high_contrast_mode,
                    value: themeState.isHighContrast,
                    onChanged: (value) => context.read<ThemeBloc>().add(
                          const ThemeEvent.toggleHighContrast(),
                        ),
                  ),
                  const _Divider(),
                  BlocBuilder<DictionaryBloc, DictionaryState>(
                    builder: (context, state) =>
                        LanguageSelector<DictionaryEnum>(
                      title: context.r.dictionary_language,
                      value: context.read<DictionaryBloc>().state.dictionary,
                      items: DictionaryEnum.values,
                      onTap: (value) => context.read<DictionaryBloc>().add(
                            DictionaryEvent.dictionaryChanged(value!),
                          ),
                    ),
                  ),
                  const _Divider(),
                  LanguageSelector<LocaleEnum>(
                    title: context.r.app_language,
                    value: context.read<LocaleBloc>().state.locale,
                    items: LocaleEnum.values,
                    onTap: (value) => context.read<LocaleBloc>().add(
                          LocaleEvent.localeChanged(value!),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _Divider extends StatelessWidget {
  // ignore: unused_element
  const _Divider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: context.dynamicColor(
        light: AppColors.greyLight,
        dark: AppColors.greyDark,
      ),
    );
  }
}
