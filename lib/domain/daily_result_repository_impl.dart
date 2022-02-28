import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:wordly/data/collections/daily_result_data.dart';
import 'package:wordly/data/models/dictionary_languages.dart';
import 'package:wordly/domain/daily_result_repository.dart';

class DailyResultRepositoryImpl implements DailyResultRepository {
  late DailyResultData _dailyResult;
  final _isar = GetIt.I<Isar>();

  @override
  DailyResultData get dailyResult => _dailyResult;

  @override
  Future<void> initDailyResult(final DictionaryLanguages language) async {
    final result = await _isar.dailyResultDatas.get(language.index);
    _dailyResult = result ?? DailyResultData.init(language.index);
  }

  @override
  Future<void> saveDailyResult({
    required final bool isWin,
    required final String word,
    required final DictionaryLanguages language,
  }) async {
    final data = DailyResultData()
      ..id = language.index
      ..isWin = isWin
      ..dailyWord = word;

    await _isar.writeTxn((isar) async {
      _dailyResult = data;
      await isar.dailyResultDatas.put(_dailyResult);
    });
  }
}
