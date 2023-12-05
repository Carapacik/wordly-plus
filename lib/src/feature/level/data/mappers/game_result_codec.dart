import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/game/domain/model/game_result.dart';

class const GameResultCodec() extends JsonMapCodec<GameResult> {
  @override
  GameResult $decode(Map<String, Object?> input) {
    return GameResult(
      secretWord: input['secretWord']! as String,
      isWin: input['win'] as bool?,
      lvlNumber: input['lvl'] as int?,
    );
  }

  @override
  Map<String, Object?> $encode(GameResult input) => {
    'secretWord': input.secretWord,
    'win': input.isWin,
    'lvl': input.lvlNumber,
  };
}
