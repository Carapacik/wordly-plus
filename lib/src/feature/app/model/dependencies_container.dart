import 'package:package_info_plus/package_info_plus.dart';
import 'package:wordly/src/feature/app/model/application_config.dart';
import 'package:wordly/src/feature/game/domain/repositories/game_repository.dart';
import 'package:wordly/src/feature/level/level.dart';
import 'package:wordly/src/feature/settings/settings.dart';
import 'package:wordly/src/feature/statistic/statistic.dart';

class const DependenciesContainer({
  required final ApplicationConfig config,
  required final PackageInfo packageInfo,
  required final SettingsContainer settingsContainer,
  required final IStatisticsRepository statisticsRepository,
  required final ILevelRepository levelRepository,
  required final IGameRepository gameRepository,
});
