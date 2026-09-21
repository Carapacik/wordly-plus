import 'package:wordly/src/feature/game/model/game_result.dart';

abstract interface class IGameDatasource() {
  Future<GameResult?> getDaily(String dictionary, String date);

  Future<void> setDailyBoard(String dictionary, String date, GameResult savedResult);

  Future<bool?> get isFirstEnter;

  Future<void> setFirstEnter();
}
