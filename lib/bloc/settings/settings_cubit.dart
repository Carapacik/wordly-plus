import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:wordly/data/collections/settings_data.dart';
import 'package:wordly/data/models/dictionary_languages.dart';
import 'package:wordly/data/models/locale_languages.dart';
import 'package:wordly/data/repositories/dictionary_repository.dart';
import 'package:wordly/domain/board_repository.dart';
import 'package:wordly/domain/daily_statistic_repository.dart';
import 'package:wordly/domain/level_repository.dart';
import 'package:wordly/domain/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(final SettingsData data)
      : super(
          SettingsInitial(
            localeLanguage: data.localeLanguage,
            dictionaryLanguage: data.dictionaryLanguage,
            isDark: data.isDark,
            isHighContrast: data.isHighContrast,
          ),
        );

  Future<void> toggleTheme({required bool value}) async {
    final settingsRepository = GetIt.I<SettingsRepository>();
    final currentSettingsData = settingsRepository.settingsData;

    emit(state.copyWith(isDark: value));
    await settingsRepository.saveSettings(currentSettingsData..isDark = value);
  }

  Future<void> toggleHighContrast({required bool value}) async {
    final settingsRepository = GetIt.I<SettingsRepository>();
    final currentSettingsData = settingsRepository.settingsData;

    emit(state.copyWith(isHighContrast: value));
    await settingsRepository
        .saveSettings(currentSettingsData..isHighContrast = value);
  }

  Future<void> changeDictionaryLanguage({required String value}) async {
    final settingsRepository = GetIt.I<SettingsRepository>();
    final levelRepository = GetIt.I<LevelRepository>();
    final dictionaryRepository = GetIt.I<DictionaryRepository>();
    final dailyStatisticRepository = GetIt.I<DailyStatisticRepository>();
    final boardRepository = GetIt.I<BoardRepository>();

    final currentSettingsData = settingsRepository.settingsData;
    final dictionaryLanguage = value.toDictionaryLanguage;

    late int levelNumber;
    if (levelRepository.isLevelMode) {
      await levelRepository.initLevelData(dictionaryLanguage);
      levelNumber = levelRepository.levelData.lastLevel;
    } else {
      levelNumber = 0;
    }
    dictionaryRepository
      ..dictionaryLanguage = dictionaryLanguage
      ..resetData()
      ..createSecretWord(levelNumber);
    await boardRepository.initBoardData(
      dictionaryLanguage: dictionaryLanguage,
      levelNumber: levelNumber,
    );
    dictionaryRepository.loadBoard();
    await dailyStatisticRepository.initStatisticData(dictionaryLanguage);
    emit(state.copyWith(dictionaryLanguage: dictionaryLanguage));
    await settingsRepository.saveSettings(
      currentSettingsData..dictionaryLanguage = dictionaryLanguage,
    );
  }

  Future<void> changeLocaleLanguage({required String value}) async {
    final settingsRepository = GetIt.I<SettingsRepository>();
    final currentSettingsData = settingsRepository.settingsData;
    final localeLanguage = value.toLocaleLanguage;

    emit(state.copyWith(localeLanguage: localeLanguage));
    await settingsRepository.saveSettings(
      currentSettingsData..localeLanguage = localeLanguage,
    );
  }
}
