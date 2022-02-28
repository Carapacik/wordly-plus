import 'dart:convert';

import 'package:wordle/data/models/settings_data.dart';
import 'package:wordle/data/repositories/save_reactive_repository.dart';
import 'package:wordle/data/shared_preferences_data.dart';

class SettingsRepository extends SaveReactiveRepository<SettingsData> {
  factory SettingsRepository.getInstance() => _instance ??=
      SettingsRepository._internal(SharedPreferenceData.getInstance());

  SettingsRepository._internal(this.spData);

  static SettingsRepository? _instance;

  final SharedPreferenceData spData;

  @override
  SettingsData convertFromString(String rawItem) =>
      SettingsData.fromJson(json.decode(rawItem) as Map<String, dynamic>);

  @override
  String convertToString(SettingsData item) => json.encode(item.toJson());

  @override
  Future<String?> getRawData() => spData.getSettingsData();

  @override
  Future<bool> setRawData(String item) => spData.saveSettingsData(item);
}
