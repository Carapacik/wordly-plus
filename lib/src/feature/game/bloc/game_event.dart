part of 'game_bloc.dart';

@Freezed(copyWith: false)
sealed class GameEvent with _$GameEvent {
  const factory changeDictionary(Locale dictionary) = _GameChangeDictionary;

  const factory changeGameMode(GameMode gameMode) = _GameChangeGameMode;

  const factory resetBoard(GameMode gameMode) = _GameResetBoard;

  const factory letterPressed(String key) = _GameLetterPressed;

  const factory deletePressed() = _GameDeletePressed;

  const factory deleteLongPressed() = _GameDeleteLongPressed;

  const factory enterPressed() = _GameEnterPressed;

  const factory retryLevelPersistence() = _GameRetryLevelPersistence;

  const factory listenKeyEvent(KeyEvent keyEvent) = _GameListenKeyEvent;
}
