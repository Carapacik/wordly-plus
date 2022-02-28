import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wordle/data/models/letter_status.dart';

part 'letter_data.freezed.dart';

@freezed
class LetterData with _$LetterData {
  const factory LetterData({
    required String letter,
    required LetterStatus status,
  }) = _LetterData;
}
