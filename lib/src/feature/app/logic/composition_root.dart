import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordly/src/feature/app/model/dependencies_container.dart';
import 'package:wordly/src/feature/game/data/daily_store.dart';
import 'package:wordly/src/feature/game/data/dictionary/dictionary_database.dart';
import 'package:wordly/src/feature/game/data/game_repository.dart';
import 'package:wordly/src/feature/level/data/database/app_database.dart';
import 'package:wordly/src/feature/level/data/level_repository.dart';
import 'package:wordly/src/feature/level/data/migration/legacy_level_migration.dart';
import 'package:wordly/src/feature/settings/data/settings_local_datasource.dart';
import 'package:wordly/src/feature/settings/data/settings_repository.dart';
import 'package:wordly/src/feature/settings/model/settings.dart';
import 'package:wordly/src/feature/statistic/data/statistics_repository.dart';
import 'package:wordly/src/logging/app_logger.dart';

Future<DependenciesContainer> composeDependencies() async {
  final stopwatch = Stopwatch()..start();

  AppLogger.info('Initializing dependencies...');
  final DependenciesContainer dependencies = await _createDependencies();

  stopwatch.stop();
  AppLogger.info('Dependencies initialized successfully in ${stopwatch.elapsedMilliseconds} ms.');

  return dependencies;
}

Future<DependenciesContainer> _createDependencies() async {
  final sharedPreferences = SharedPreferencesAsync();

  final PackageInfo packageInfo = await PackageInfo.fromPlatform();

  final settingsRepository = SettingsRepository(
    localDatasource: SettingsLocalDatasourceSharedPreferences(sharedPreferences: sharedPreferences),
  );
  final Settings initialSettings = await settingsRepository.read();
  final levelDatabase = AppDatabase.defaults();
  final closeOnFailure = <Future<void> Function()>[levelDatabase.close];
  try {
    final dailyStore = DailyStore(database: levelDatabase, preferences: sharedPreferences);
    await dailyStore.importLegacyStatistics();
    final ruDatabase = DictionaryDatabase.asset('ru');
    closeOnFailure.add(ruDatabase.close);
    final enDatabase = DictionaryDatabase.asset('en');
    closeOnFailure.add(enDatabase.close);
    final gameRepository = GameRepository(
      gameDataSource: SqliteGameDatasource(store: dailyStore, preferences: sharedPreferences),
      ruDatabase: ruDatabase,
      enDatabase: enDatabase,
    );
    await gameRepository.init(initialSettings.dictionary);

    final legacyLevelMigration = LegacyLevelMigration(
      database: levelDatabase,
      legacyStore: SharedPreferencesLegacyLevelStore(sharedPreferences),
      logWarning: AppLogger.warning,
    );
    await legacyLevelMigration.run();
    final levelRepository = LevelRepository(database: levelDatabase);

    final IStatisticsRepository statisticsRepository = StatisticsRepository(
      statisticsDatasource: SqliteStatisticDatasource(store: dailyStore),
    );

    return DependenciesContainer(
      packageInfo: packageInfo,
      settingsRepository: settingsRepository,
      initialSettings: initialSettings,
      gameRepository: gameRepository,
      levelRepository: levelRepository,
      statisticsRepository: statisticsRepository,
    );
  } on Object {
    for (final Future<void> Function() close in closeOnFailure.reversed) {
      try {
        await close();
      } on Object catch (error, stackTrace) {
        AppLogger.warning('Could not close database after initialization failed', error: error, stackTrace: stackTrace);
      }
    }
    rethrow;
  }
}
