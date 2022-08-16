part of 'levels_bloc.dart';

@Freezed()
class LevelsEvent with _$LevelsEvent {
  const LevelsEvent._();

  const factory LevelsEvent.levelsLoad(DictionaryEnum dictionary) =
      _LevelsLoadEvent;
}
