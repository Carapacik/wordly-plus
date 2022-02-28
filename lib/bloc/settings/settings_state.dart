part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.language,
    required this.isDarkThemeOn,
    required this.isHighContrast,
  });

  // TODO: replace with freezed
  final String language;
  final bool isDarkThemeOn;
  final bool isHighContrast;

  @override
  List<Object?> get props => [isDarkThemeOn, isHighContrast, language];

  SettingsState copyWith({
    bool? isDarkThemeOn,
    bool? isHighContrast,
    String? language,
  }) {
    return SettingsState(
      isDarkThemeOn: isDarkThemeOn ?? this.isDarkThemeOn,
      isHighContrast: isHighContrast ?? this.isHighContrast,
      language: language ?? this.language,
    );
  }
}
