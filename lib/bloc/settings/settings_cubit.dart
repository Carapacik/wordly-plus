import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wordle/data/models/settings_data.dart';
import 'package:wordle/data/repositories/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required SettingsData item})
      : super(
          SettingsState(
            isDarkThemeOn: item.isDarkTheme,
            isHighContrast: item.isHighContrast,
            language: item.appLanguage,
          ),
        );

  @override
  Future<void> onChange(Change<SettingsState> change) async {
    super.onChange(change);
    await SettingsRepository.getInstance().setItem(
      SettingsData(
        isDarkTheme: change.nextState.isDarkThemeOn,
        isHighContrast: change.nextState.isHighContrast,
        appLanguage: change.nextState.language,
      ),
    );
  }

  void toggleTheme({required bool value}) => emit(
        state.copyWith(isDarkThemeOn: value),
      );

  void toggleContrast({required bool value}) => emit(
        state.copyWith(isHighContrast: value),
      );

  void changeLanguage({required String value}) => emit(
        state.copyWith(language: value),
      );
}
