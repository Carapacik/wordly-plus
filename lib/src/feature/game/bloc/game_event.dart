part of 'game_bloc.dart';

@Freezed(copyWith: false)
sealed class GameEvent with _$GameEvent {
  const factory GameEvent.changeDictionary(Locale dictionary) = _GameChangeDictionary;

  const factory GameEvent.changeGameMode(GameMode gameMode) = _GameChangeGameMode;

  const factory GameEvent.resetBoard(GameMode gameMode) = _GameResetBoard;

  const factory GameEvent.letterPressed(String key) = _GameLetterPressed;

  const factory GameEvent.deletePressed() = _GameDeletePressed;

  const factory GameEvent.deleteLongPressed() = _GameDeleteLongPressed;

  const factory GameEvent.enterPressed() = _GameEnterPressed;

  const factory GameEvent.retryLevelPersistence() = _GameRetryLevelPersistence;

  const factory GameEvent.listenKeyEvent(KeyEvent keyEvent) = _GameListenKeyEvent;
}
