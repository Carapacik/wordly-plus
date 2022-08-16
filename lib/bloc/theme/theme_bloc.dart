import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wordly/data/repositories.dart';

part 'theme_bloc.freezed.dart';
part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc({
    required this.settingsRepository,
    required bool isDarkTheme,
    required bool isHighContrast,
  }) : super(
          ThemeState.changeTheme(
            isDarkTheme: isDarkTheme,
            isHighContrast: isHighContrast,
          ),
        ) {
    on<_ToggleThemeEvent>(_onThemeChanged);
    on<_ToggleHighContrastEvent>(_onHighContrastChanged);
  }

  final ISaveSettingsRepository settingsRepository;

  Future<void> _onThemeChanged(
    _ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    await settingsRepository.saveDark(value: !state.isDarkTheme);
    emit(state.copyWith(isDarkTheme: !state.isDarkTheme));
  }

  Future<void> _onHighContrastChanged(
    _ToggleHighContrastEvent event,
    Emitter<ThemeState> emit,
  ) async {
    await settingsRepository.saveHighContrast(value: !state.isHighContrast);
    emit(state.copyWith(isHighContrast: !state.isHighContrast));
  }
}
