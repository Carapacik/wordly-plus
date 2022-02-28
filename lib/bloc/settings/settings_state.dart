part of 'settings_cubit.dart';

abstract class SettingsState extends Equatable {
  const SettingsState({
    required this.dictionaryLanguage,
    required this.localeLanguage,
    required this.isDark,
    required this.isHighContrast,
  });

  final DictionaryLanguages dictionaryLanguage;
  final LocaleLanguages localeLanguage;
  final bool isDark;
  final bool isHighContrast;

  SettingsState copyWith({
    DictionaryLanguages? dictionaryLanguage,
    LocaleLanguages? localeLanguage,
    bool? isDark,
    bool? isHighContrast,
  }) =>
      SettingsUpdate(
        dictionaryLanguage: dictionaryLanguage ?? this.dictionaryLanguage,
        localeLanguage: localeLanguage ?? this.localeLanguage,
        isDark: isDark ?? this.isDark,
        isHighContrast: isHighContrast ?? this.isHighContrast,
      );

  @override
  List<Object> get props =>
      [dictionaryLanguage, localeLanguage, isDark, isHighContrast];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial({
    required super.dictionaryLanguage,
    required super.localeLanguage,
    required super.isDark,
    required super.isHighContrast,
  });
}

class SettingsUpdate extends SettingsState {
  const SettingsUpdate({
    required super.dictionaryLanguage,
    required super.localeLanguage,
    required super.isDark,
    required super.isHighContrast,
  });
}
