import 'package:clock/clock.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordly/src/feature/app/model/application_config.dart';
import 'package:wordly/src/feature/app/model/dependencies_container.dart';
import 'package:wordly/src/feature/game/data/datasources/game_datasource.dart';
import 'package:wordly/src/feature/game/domain/repositories/game_repository.dart';
import 'package:wordly/src/feature/level/level.dart';
import 'package:wordly/src/feature/settings/settings.dart';
import 'package:wordly/src/feature/statistic/statistic.dart';

Future<CompositionResult> composeDependencies({required ApplicationConfig config}) async {
  final Stopwatch stopwatch = clock.stopwatch()..start();

  logger.info('Initializing dependencies...');

  // Create the dependencies container using functions.
  final DependenciesContainer dependencies = await createDependenciesContainer(config);

  stopwatch.stop();
  logger.info('Dependencies initialized successfully in ${stopwatch.elapsedMilliseconds} ms.');

  return CompositionResult(dependencies: dependencies, millisecondsSpent: stopwatch.elapsedMilliseconds);
}

final class CompositionResult {
  const CompositionResult({required this.dependencies, required this.millisecondsSpent});

  final DependenciesContainer dependencies;
  final int millisecondsSpent;

  @override
  String toString() =>
      'CompositionResult('
      'dependencies: $dependencies, '
      'millisecondsSpent: $millisecondsSpent'
      ')';
}

Future<DependenciesContainer> createDependenciesContainer(ApplicationConfig config) async {
  final sharedPreferences = SharedPreferencesAsync();

  final PackageInfo packageInfo = await PackageInfo.fromPlatform();

  final SettingsContainer settingsContainer = await SettingsContainer.create(sharedPreferences: sharedPreferences);
  final gameRepository = GameRepository(gameDataSource: GameDatasource(sharedPreferences: sharedPreferences));
  await gameRepository.init(settingsContainer.settingsService.current.dictionary);

  final levelDatabase = AppDatabase.defaults();
  final legacyLevelMigration = LegacyLevelMigration(
    database: levelDatabase,
    legacyStore: SharedPreferencesLegacyLevelStore(sharedPreferences),
    logWarning: logger.warn,
  );
  await legacyLevelMigration.run();
  final levelRepository = LevelRepository(database: levelDatabase);

  final IStatisticsRepository statisticsRepository = StatisticsRepository(
    statisticsDatasource: StatisticDatasource(sharedPreferences: sharedPreferences),
  );

  return DependenciesContainer(
    config: config,
    packageInfo: packageInfo,
    settingsContainer: settingsContainer,
    gameRepository: gameRepository,
    levelRepository: levelRepository,
    statisticsRepository: statisticsRepository,
  );
}
