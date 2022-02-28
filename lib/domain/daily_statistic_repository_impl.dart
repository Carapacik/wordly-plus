import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:wordly/data/collections/daily_statistic_data.dart';
import 'package:wordly/data/models/dictionary_languages.dart';
import 'package:wordly/domain/daily_statistic_repository.dart';

class DailyStatisticRepositoryImpl implements DailyStatisticRepository {
  late DailyStatisticData _statisticData;
  final _isar = GetIt.I<Isar>();

  @override
  DailyStatisticData get statisticData => _statisticData;

  @override
  Future<void> initStatisticData(
    final DictionaryLanguages dictionaryLanguage,
  ) async {
    final result =
        await _isar.dailyStatisticDatas.get(dictionaryLanguage.index);
    _statisticData =
        result ?? DailyStatisticData.init(dictionaryLanguage.index);
  }

  @override
  Future<void> saveStatisticData({
    required final bool isWin,
    required final int attempt,
  }) async {
    final attempts = _statisticData.attempts;
    if (isWin) {
      attempts[attempt - 1] = _statisticData.attempts[attempt - 1] + 1;
    }
    if (isWin) {
      _statisticData.copyWith(
        winsNumber: _statisticData.winsNumber++,
        currentStreak: _statisticData.currentStreak++,
        attempts: attempts,
      );
    } else {
      _statisticData.copyWith(
        losesNumber: _statisticData.losesNumber++,
        currentStreak: 0,
        attempts: attempts,
      );
    }
    await _isar.writeTxn((isar) async {
      await isar.dailyStatisticDatas.put(_statisticData);
    });
  }
}
