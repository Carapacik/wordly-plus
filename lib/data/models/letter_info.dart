import 'package:equatable/equatable.dart';
import 'package:wordly/data/models/letter_status.dart';

class LetterInfo extends Equatable {
  const LetterInfo({
    required this.letter,
    required this.letterStatus,
  });

  final String letter;
  final LetterStatus letterStatus;

  @override
  List<Object?> get props => [letter, letterStatus];
}
