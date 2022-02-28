part of 'main_cubit.dart';

abstract class MainState extends Equatable {
  const MainState();
}

class MainInitial extends MainState {
  @override
  List<Object> get props => [];
}

class GridUpdateState extends MainState {
  final id = DateTime.now().microsecondsSinceEpoch;

  @override
  List<Object?> get props => [id];
}

class KeyboardKeyUpdateState extends MainState {
  KeyboardKeyUpdateState(this.keyboardKey, this.letterStatus);

  final id = DateTime.now().microsecondsSinceEpoch;
  final KeyboardKeys keyboardKey;
  final LetterStatus letterStatus;

  @override
  List<Object?> get props => [id, keyboardKey, letterStatus];
}

class TopMessageState extends MainState {
  TopMessageState(this.type);

  final id = DateTime.now().microsecondsSinceEpoch;
  final SnackbarType type;

  @override
  List<Object?> get props => [id, type];
}

class LoseGameState extends MainState {
  @override
  List<Object?> get props => [];
}

class WinGameState extends MainState {
  @override
  List<Object?> get props => [];
}
