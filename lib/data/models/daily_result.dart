import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_result.freezed.dart';
part 'daily_result.g.dart';

@freezed
class DailyResult with _$DailyResult {
  const factory DailyResult({
    required String word,
    @Default(true) bool isWin,
  }) = _DailyResult;

  factory DailyResult.fromJson(Map<String, dynamic> json) =>
      _$DailyResultFromJson(json);
}
