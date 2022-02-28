import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wordle/data/models/letter_status.dart';

part 'board_data.freezed.dart';
part 'board_data.g.dart';

@freezed
class BoardData with _$BoardData {
  const factory BoardData({
    @Default(false) bool ruComplete,
    @Default(false) bool enComplete,
    Map<String, LetterStatus>? enKeyboard,
    Map<String, LetterStatus>? ruKeyboard,
    @Default(0) int enIndex,
    @Default(0) int ruIndex,
    String? enWord,
    String? ruWord,
    List<String>? enBoard,
    List<String>? ruBoard,
  }) = _BoardData;

  factory BoardData.fromJson(Map<String, dynamic> json) =>
      _$BoardDataFromJson(json);
}
