import 'package:wordly/src/feature/game/domain/model/letter_info.dart';

class const GameResult({
  required final String secretWord,
  final List<LetterInfo> board = const [],
  final bool? isWin,
  final int? lvlNumber,
}) {
  factory fromJson(Map<String, dynamic> json) => GameResult(
    board: [],
    secretWord: json['secretWord'] as String,
    isWin: json['win'] as bool?,
    lvlNumber: json['lvl'] as int?,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{'secretWord': secretWord, 'win': isWin, 'lvl': lvlNumber};
}
