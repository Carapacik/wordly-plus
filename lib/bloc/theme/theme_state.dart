part of 'theme_bloc.dart';

@Freezed(copyWith: true)
class ThemeState with _$ThemeState {
  const factory ThemeState.changeTheme({
    required bool isDarkTheme,
    required bool isHighContrast,
  }) = _ChangeThemeState;
}
