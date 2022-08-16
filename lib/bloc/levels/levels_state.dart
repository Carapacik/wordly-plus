part of 'levels_bloc.dart';

@Freezed()
class LevelsState with _$LevelsState {
  const LevelsState._();

  const factory LevelsState.initial() = _InitialState;

  const factory LevelsState.levelsLoaded(List<GameResult> levels) =
      _LevelsLoadedState;
}
