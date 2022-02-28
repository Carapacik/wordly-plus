import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:wordly/data/collections/board_data.dart';
import 'package:wordly/data/models/dictionary_languages.dart';
import 'package:wordly/domain/board_repository.dart';
import 'package:wordly/domain/settings_repository.dart';

class BoardRepositoryImpl implements BoardRepository {
  late BoardData _boardData;
  final _isar = GetIt.I<Isar>();

  @override
  BoardData get boardData => _boardData;

  @override
  Future<void> initBoardData({
    required final DictionaryLanguages dictionaryLanguage,
    required final int levelNumber,
  }) async {
    late BoardData finalData;
    final data = await _isar.boardDatas
        .filter()
        .languageEqualTo(dictionaryLanguage)
        .levelNumberEqualTo(levelNumber)
        .findAll();
    // Sort by id
    if (data.isEmpty) {
      finalData = BoardData.init(
        language: dictionaryLanguage,
        levelNumber: levelNumber,
      );
    } else {
      try {
        data.sort((a, b) => a.id!.compareTo(b.id!));
        finalData = data.firstOrNull ??
            BoardData.init(
              language: dictionaryLanguage,
              levelNumber: levelNumber,
            );
      } on Exception {
        finalData = BoardData.init(
          language: dictionaryLanguage,
          levelNumber: levelNumber,
        );
      }
    }
    _boardData = finalData;
  }

  @override
  Future<void> saveBoardData(final BoardData data) async {
    final fixedData = data..id = _boardData.id;
    await _isar.writeTxn((isar) async {
      _boardData = fixedData;
      await isar.boardDatas.put(_boardData);
    });
  }

  @override
  Future<List<BoardData>> getAllData() async {
    final language =
        GetIt.I<SettingsRepository>().settingsData.dictionaryLanguage;
    final data = await _isar.boardDatas
        .filter()
        .languageEqualTo(language)
        .levelNumberGreaterThan(0)
        .findAll();
    return data;
  }

  @override
  Future<bool> isFirstLaunch() async {
    final data = await _isar.boardDatas.count();
    return data == 0;
  }
}
