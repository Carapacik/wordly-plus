import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/bloc/settings/settings_cubit.dart';
import 'package:wordly/presentation/pages/settings/widgets/language_selector.dart';
import 'package:wordly/presentation/pages/settings/widgets/toggle_list_tile.dart';
import 'package:wordly/presentation/widgets/widgets.dart';
import 'package:wordly/resources/resources.dart';
import 'package:wordly/utils/utils.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppBar(title: R.stringsOf(context).settings),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final settingsCubit = context.read<SettingsCubit>();
            return ConstraintScreen(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    ToggleListTile(
                      text: R.stringsOf(context).dark_mode,
                      value: state.isDark,
                      onChanged: (value) =>
                          settingsCubit.toggleTheme(value: value),
                      isHighContrast: state.isHighContrast,
                    ),
                    const Divider(color: AppColors.grey),
                    ToggleListTile(
                      text: R.stringsOf(context).high_contrast_mode,
                      value: state.isHighContrast,
                      onChanged: (value) =>
                          settingsCubit.toggleHighContrast(value: value),
                      isHighContrast: state.isHighContrast,
                    ),
                    const Divider(color: AppColors.grey),
                    LanguageSelector(
                      text: R.stringsOf(context).app_language,
                      value: state.localeLanguage.name,
                      onChanged: (value) =>
                          settingsCubit.changeLocaleLanguage(value: value!),
                      isHighContrast: state.isHighContrast,
                    ),
                    const Divider(color: AppColors.grey),
                    LanguageSelector(
                      text: R.stringsOf(context).dictionary_language,
                      value: state.dictionaryLanguage.name,
                      onChanged: (value) {
                        settingsCubit.changeDictionaryLanguage(value: value!);
                      },
                      isHighContrast: state.isHighContrast,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
}
