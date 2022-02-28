import 'package:wordly/data/collections/daily_statistic_data.dart';
import 'package:wordly/data/models/dictionary_languages.dart';

abstract class DailyStatisticRepository {
  DailyStatisticData get statisticData;

  Future<void> initStatisticData(final DictionaryLanguages dictionaryLanguage);

  Future<void> saveStatisticData({
    required final bool isWin,
    required final int attempt,
  });
}
