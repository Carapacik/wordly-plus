import 'package:wordly/src/feature/game/model/letter_info.dart';

class const GameResult({
  required final String secretWord,
  final List<LetterInfo> board = const [],
  final bool? isWin,
  final int? lvlNumber,
  final DateTime? dailyDate,
});
