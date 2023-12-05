import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/game/data/mappers/game_result_board_codec.dart';
import 'package:wordly/src/feature/game/domain/model/game_mode.dart';
import 'package:wordly/src/feature/game/domain/model/game_result.dart';

abstract interface class IGameDatasource() {
  Future<GameResult?> getDaily(String dictionary, String date);

  Future<void> setDailyBoard(String dictionary, String date, GameResult savedResult);

  Future<bool?> get isFirstEnter;

  Future<void> setFirstEnter();
}

final class GameDatasource({
  required final SharedPreferencesAsync sharedPreferences,
  final GameResultBoardCodec gameResultCodec = const GameResultBoardCodec(),
}) implements IGameDatasource {
  SharedPreferencesColumnJson _board(String dictionaryKey, int index) =>
      SharedPreferencesColumnJson(sharedPreferences: sharedPreferences, key: 'game.board.$dictionaryKey.$index');

  SharedPreferencesColumnBoolean get _isFirstEnter =>
      SharedPreferencesColumnBoolean(sharedPreferences: sharedPreferences, key: 'game.isFirstEnter');

  @override
  Future<GameResult?> getDaily(String dictionary, String date) async {
    final Map<String, Object?>? rawResult = await _board(dictionary, GameMode.daily.index).read();
    if (rawResult == null) {
      return null;
    }
    try {
      final String storedDate = rawResult['date']?.toString() ?? '';
      if (date != storedDate) {
        return null;
      }
      final Map<String, Object?> normalized = _normalizeBoard(rawResult);
      return gameResultCodec.decode(normalized);
    } on Object {
      return null;
    }
  }

  @override
  Future<void> setDailyBoard(String dictionary, String date, GameResult savedResult) => _board(
    dictionary,
    GameMode.daily.index,
  ).set(<String, Object?>{...gameResultCodec.encode(savedResult), 'date': date});

  @override
  Future<bool?> get isFirstEnter => _isFirstEnter.read();

  @override
  Future<void> setFirstEnter() => _isFirstEnter.set(false);
}

Map<String, Object?> _normalizeBoard(Map<String, Object?> input) {
  final Object? rawBoard = input['board'];
  final List<Map<String, Object?>> board = switch (rawBoard) {
    null => const [],
    final List<dynamic> list =>
      list
          .map((entry) {
            if (entry is Map<String, Object?>) {
              return entry;
            }
            if (entry is Map) {
              return Map<String, Object?>.from(entry);
            }
            throw const FormatException('Invalid board entry');
          })
          .toList(growable: false),
    final String rawString => _decodeLegacyBoard(rawString),
    _ => throw const FormatException('Invalid board payload'),
  };
  return <String, Object?>{...input, 'board': board};
}

List<Map<String, Object?>> _decodeLegacyBoard(String rawBoard) {
  final String trimmed = rawBoard.trim();
  if (trimmed.isEmpty) {
    return const [];
  }
  return trimmed
      .split('|')
      .map((entry) {
        final Object? decoded = jsonDecode(entry);
        if (decoded is! Map) {
          throw const FormatException('Invalid legacy board entry');
        }
        return Map<String, Object?>.from(decoded);
      })
      .toList(growable: false);
}
