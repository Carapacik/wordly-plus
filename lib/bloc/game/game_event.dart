part of 'game_bloc.dart';

typedef TextFunction = String Function(Object, Object);

@Freezed()
class GameEvent with _$GameEvent {
  const GameEvent._();

  const factory GameEvent.letterPressed(KeyboardKeys letter) =
      _LetterPressedEvent;

  const factory GameEvent.keyListen(RawKeyDownEvent keyDown) = _KeyListenEvent;

  const factory GameEvent.deletePressed() = _DeletePressedEvent;

  const factory GameEvent.deleteLongPressed() = _DeleteLongPressedEvent;

  const factory GameEvent.enterPressed() = _EnterPressedEvent;

  const factory GameEvent.loadGame({
    @Default(true) bool isDaily,
    @Default(true) bool isFirst,
  }) = _LoadGameEvent;

  const factory GameEvent.share({required TextFunction textFunction}) =
      _ShareEvent;

  const factory GameEvent.changeDictionary(DictionaryEnum dictionary) =
      _ChangeDictionaryEvent;
}
