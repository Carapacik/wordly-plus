import 'package:wordly/data/collections/daily_result_data.dart';
import 'package:wordly/data/models/dictionary_languages.dart';

abstract class DailyResultRepository {
  DailyResultData get dailyResult;

  Future<void> initDailyResult(final DictionaryLanguages dictionaryLanguage);

  Future<void> saveDailyResult({
    required final bool isWin,
    required final String word,
    required final DictionaryLanguages language,
  });
}
