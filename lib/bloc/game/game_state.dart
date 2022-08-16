part of 'game_bloc.dart';

@Freezed()
class GameState with _$GameState {
  const GameState._();

  const factory GameState.initial() = _InitialState;

  const factory GameState.complete({
    required GameResult result,
    @Default(true) bool isDaily,
  }) = _CompleteGameState;

  const factory GameState.error(GameError error) = _ErrorState;

  const factory GameState.boardUpdate(List<LetterInfo> board) =
      _BoardUpdateState;

  const factory GameState.wordSubmit({
    required final List<LetterInfo> board,
    required final Map<KeyboardKeys, LetterStatus> keyboard,
  }) = _WordSumbitState;

  bool get isUpdate => this is _BoardUpdateState || this is _WordSumbitState;

  bool get isSubmit => this is _WordSumbitState;

  bool get isGameComplete => this is _CompleteGameState;
}
