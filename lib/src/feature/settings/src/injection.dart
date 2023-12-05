import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordly/src/feature/settings/src/application/settings_service.dart';
import 'package:wordly/src/feature/settings/src/data/datasources/settings_local_datasource.dart';
import 'package:wordly/src/feature/settings/src/data/repositories/settings_repository_impl.dart';

/// Container with global settings state.
class const SettingsContainer._(
  /// Service for managing settings.
  final SettingsService settingsService,
) {
  /// Create a new [SettingsContainer] with the given [sharedPreferences].
  static Future<SettingsContainer> create({required SharedPreferencesAsync sharedPreferences}) async {
    final settingsRepository = SettingsRepositoryImpl(
      localDatasource: SettingsLocalDatasourceSharedPreferences(sharedPreferences: sharedPreferences),
    );

    final SettingsServiceImpl settingsService = await SettingsServiceImpl.create(repository: settingsRepository);

    return SettingsContainer._(settingsService);
  }
}
