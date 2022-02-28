import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_attempt.freezed.dart';
part 'game_attempt.g.dart';

@freezed
class GameAttempt with _$GameAttempt {
  const factory GameAttempt({
    @Default(0) int first,
    @Default(0) int second,
    @Default(0) int third,
    @Default(0) int fourth,
    @Default(0) int fifth,
    @Default(0) int sixth,
  }) = _GameAttempt;

  factory GameAttempt.fromJson(Map<String, dynamic> json) =>
      _$GameAttemptFromJson(json);
}
