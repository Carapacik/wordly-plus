import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wordle/data/models/game_attempt.dart';

part 'game_statistic.freezed.dart';
part 'game_statistic.g.dart';

@freezed
class GameStatistic with _$GameStatistic {
  const factory GameStatistic({
    @Default(0) int wins,
    @Default(0) int loses,
    @Default(0) int maxStreak,
    @Default(0) int currentStreak,
    @Default(GameAttempt()) GameAttempt gameAttempt,
  }) = _GameStatistic;

  factory GameStatistic.fromJson(Map<String, dynamic> json) =>
      _$GameStatisticFromJson(json);
}
