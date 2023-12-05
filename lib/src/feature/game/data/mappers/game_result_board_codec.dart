import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/game/domain/model/game_result.dart';
import 'package:wordly/src/feature/game/domain/model/letter_info.dart';

class const GameResultBoardCodec() extends JsonMapCodec<GameResult> {
  @override
  GameResult $decode(Map<String, Object?> input) {
    final Object? secretWord = input['secretWord'];
    if (secretWord is! String) {
      throw const FormatException('Missing secret word');
    }
    final rawBoard = input['board'] as List<dynamic>?;
    final List<LetterInfo> board = rawBoard == null
        ? const []
        : rawBoard.map((entry) => LetterInfo.fromJson(entry as Map<String, Object?>)).toList(growable: false);
    return GameResult(
      secretWord: secretWord,
      board: board,
      isWin: input['win'] as bool?,
      lvlNumber: input['lvl'] as int?,
    );
  }

  @override
  Map<String, Object?> $encode(GameResult input) => <String, Object?>{
    'secretWord': input.secretWord,
    'board': input.board.map((entry) => entry.toJson()).toList(growable: false),
    'win': input.isWin,
    'lvl': input.lvlNumber,
  };
}
