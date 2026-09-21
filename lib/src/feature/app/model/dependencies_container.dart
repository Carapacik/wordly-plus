import 'package:package_info_plus/package_info_plus.dart';
import 'package:wordly/src/feature/game/data/game_repository.dart';
import 'package:wordly/src/feature/level/data/level_repository.dart';
import 'package:wordly/src/feature/settings/data/settings_repository.dart';
import 'package:wordly/src/feature/settings/model/settings.dart';
import 'package:wordly/src/feature/statistic/data/statistics_repository.dart';

class const DependenciesContainer({
  required final PackageInfo packageInfo,
  required final ISettingsRepository settingsRepository,
  required final Settings initialSettings,
  required final IStatisticsRepository statisticsRepository,
  required final ILevelRepository levelRepository,
  required final IGameRepository gameRepository,
});
