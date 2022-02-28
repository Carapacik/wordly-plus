part of 'main_cubit.dart';

abstract class MainState extends Equatable {
  const MainState();
}

class ChangeDictionaryState extends MainState {
  const ChangeDictionaryState(this.dictionary);

  final String dictionary;

  @override
  List<Object?> get props => [dictionary];
}

class GridUpdateState extends MainState {
  final id = DateTime.now().microsecondsSinceEpoch;

  @override
  List<Object?> get props => [id];
}

class KeyboardKeyUpdateState extends MainState {
  KeyboardKeyUpdateState(this.keyboardKey, this.letterType);

  final id = DateTime.now().microsecondsSinceEpoch;
  final KeyboardKeys keyboardKey;
  final LetterStatus letterType;

  @override
  List<Object?> get props => [id, keyboardKey, letterType];
}

class TopMessageState extends MainState {
  TopMessageState(this.type);

  final id = DateTime.now().microsecondsSinceEpoch;
  final FlushBarTypes type;

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
