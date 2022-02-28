import 'dart:convert';

import 'package:wordle/data/models/board_data.dart';
import 'package:wordle/data/repositories/save_reactive_repository.dart';
import 'package:wordle/data/shared_preferences_data.dart';

class BoardStateRepository extends SaveReactiveRepository<BoardData> {
  factory BoardStateRepository.getInstance() => _instance ??=
      BoardStateRepository._internal(SharedPreferenceData.getInstance());

  BoardStateRepository._internal(this.spData);

  static BoardStateRepository? _instance;

  final SharedPreferenceData spData;

  @override
  BoardData convertFromString(String rawItem) =>
      BoardData.fromJson(json.decode(rawItem) as Map<String, dynamic>);

  @override
  String convertToString(BoardData item) => json.encode(item.toJson());

  @override
  Future<String?> getRawData() => spData.getBoardData();

  @override
  Future<bool> setRawData(String item) => spData.saveBoardData(item);
}
