import 'package:equatable/equatable.dart';
import 'package:wordly/data/models/letter_info.dart';

class IndexedLetterInfo extends Equatable {
  const IndexedLetterInfo({
    required this.indexInWord,
    required this.info,
  });

  final int indexInWord;
  final LetterInfo info;

  @override
  List<Object?> get props => [indexInWord, info];
}
