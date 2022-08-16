import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wordly/data/models/letter_status.dart';

part 'letter_info.freezed.dart';
part 'letter_info.g.dart';

@Freezed()
class LetterInfo with _$LetterInfo {
  const factory LetterInfo({
    required String letter,
    @Default(LetterStatus.unknown) LetterStatus letterStatus,
  }) = _LetterInfo;

  const factory LetterInfo.empty({
    @Default('') String letter,
    @Default(LetterStatus.unknown) LetterStatus letterStatus,
  }) = _LetterInfoEmpty;

  factory LetterInfo.fromJson(Map<String, dynamic> json) =>
      _$LetterInfoFromJson(json);
}
