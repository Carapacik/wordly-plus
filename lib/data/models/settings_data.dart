import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_data.freezed.dart';
part 'settings_data.g.dart';

@freezed
class SettingsData with _$SettingsData {
  const factory SettingsData({
    @Default(false) bool isDarkTheme,
    @Default(false) bool isHighContrast,
    @Default('en') String appLanguage,
  }) = _SettingsData;

  factory SettingsData.fromJson(Map<String, dynamic> json) =>
      _$SettingsDataFromJson(json);
}
