import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/core/constant/localization/localization.dart';
import 'package:wordly/src/feature/settings/settings.dart';
import 'package:wordly/src/feature/settings/src/data/mappers/settings_codec.dart';

abstract interface class SettingsLocalDatasource() {
  Future<Settings> read();

  Future<void> save(Settings settings);
}

final class const SettingsLocalDatasourceSharedPreferences({
  required final SharedPreferencesAsync sharedPreferences,
  final SettingsCodec settingsCodec = const SettingsCodec(),
}) implements SettingsLocalDatasource {
  SharedPreferencesColumnJson get sharedPreferencesColumnJson =>
      SharedPreferencesColumnJson(sharedPreferences: sharedPreferences, key: 'settings');

  @override
  Future<void> save(Settings settings) async {
    final Map<String, Object?> settingsMap = settingsCodec.encode(settings);

    await sharedPreferencesColumnJson.set(settingsMap);
  }

  @override
  Future<Settings> read() async {
    final Map<String, Object?>? settingsMap = await sharedPreferencesColumnJson.read();
    if (settingsMap == null) {
      return Settings(
        general: GeneralSettings(locale: Localization.computeDefaultLocale()),
        dictionary: Localization.computeDefaultLocale(withDictionary: true),
      );
    }

    return settingsCodec.decode(settingsMap);
  }
}
