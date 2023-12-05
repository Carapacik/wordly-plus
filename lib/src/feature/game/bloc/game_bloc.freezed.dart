// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameEvent()';
}


}




/// Adds pattern-matching-related methods to [GameEvent].
extension GameEventPatterns on GameEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _GameChangeDictionary value)?  changeDictionary,TResult Function( _GameChangeGameMode value)?  changeGameMode,TResult Function( _GameResetBoard value)?  resetBoard,TResult Function( _GameLetterPressed value)?  letterPressed,TResult Function( _GameDeletePressed value)?  deletePressed,TResult Function( _GameDeleteLongPressed value)?  deleteLongPressed,TResult Function( _GameEnterPressed value)?  enterPressed,TResult Function( _GameRetryLevelPersistence value)?  retryLevelPersistence,TResult Function( _GameListenKeyEvent value)?  listenKeyEvent,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameChangeDictionary() when changeDictionary != null:
return changeDictionary(_that);case _GameChangeGameMode() when changeGameMode != null:
return changeGameMode(_that);case _GameResetBoard() when resetBoard != null:
return resetBoard(_that);case _GameLetterPressed() when letterPressed != null:
return letterPressed(_that);case _GameDeletePressed() when deletePressed != null:
return deletePressed(_that);case _GameDeleteLongPressed() when deleteLongPressed != null:
return deleteLongPressed(_that);case _GameEnterPressed() when enterPressed != null:
return enterPressed(_that);case _GameRetryLevelPersistence() when retryLevelPersistence != null:
return retryLevelPersistence(_that);case _GameListenKeyEvent() when listenKeyEvent != null:
return listenKeyEvent(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _GameChangeDictionary value)  changeDictionary,required TResult Function( _GameChangeGameMode value)  changeGameMode,required TResult Function( _GameResetBoard value)  resetBoard,required TResult Function( _GameLetterPressed value)  letterPressed,required TResult Function( _GameDeletePressed value)  deletePressed,required TResult Function( _GameDeleteLongPressed value)  deleteLongPressed,required TResult Function( _GameEnterPressed value)  enterPressed,required TResult Function( _GameRetryLevelPersistence value)  retryLevelPersistence,required TResult Function( _GameListenKeyEvent value)  listenKeyEvent,}){
final _that = this;
switch (_that) {
case _GameChangeDictionary():
return changeDictionary(_that);case _GameChangeGameMode():
return changeGameMode(_that);case _GameResetBoard():
return resetBoard(_that);case _GameLetterPressed():
return letterPressed(_that);case _GameDeletePressed():
return deletePressed(_that);case _GameDeleteLongPressed():
return deleteLongPressed(_that);case _GameEnterPressed():
return enterPressed(_that);case _GameRetryLevelPersistence():
return retryLevelPersistence(_that);case _GameListenKeyEvent():
return listenKeyEvent(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _GameChangeDictionary value)?  changeDictionary,TResult? Function( _GameChangeGameMode value)?  changeGameMode,TResult? Function( _GameResetBoard value)?  resetBoard,TResult? Function( _GameLetterPressed value)?  letterPressed,TResult? Function( _GameDeletePressed value)?  deletePressed,TResult? Function( _GameDeleteLongPressed value)?  deleteLongPressed,TResult? Function( _GameEnterPressed value)?  enterPressed,TResult? Function( _GameRetryLevelPersistence value)?  retryLevelPersistence,TResult? Function( _GameListenKeyEvent value)?  listenKeyEvent,}){
final _that = this;
switch (_that) {
case _GameChangeDictionary() when changeDictionary != null:
return changeDictionary(_that);case _GameChangeGameMode() when changeGameMode != null:
return changeGameMode(_that);case _GameResetBoard() when resetBoard != null:
return resetBoard(_that);case _GameLetterPressed() when letterPressed != null:
return letterPressed(_that);case _GameDeletePressed() when deletePressed != null:
return deletePressed(_that);case _GameDeleteLongPressed() when deleteLongPressed != null:
return deleteLongPressed(_that);case _GameEnterPressed() when enterPressed != null:
return enterPressed(_that);case _GameRetryLevelPersistence() when retryLevelPersistence != null:
return retryLevelPersistence(_that);case _GameListenKeyEvent() when listenKeyEvent != null:
return listenKeyEvent(_that);case _:
  return null;

}
}

}

/// @nodoc


class _GameChangeDictionary implements GameEvent {
  const _GameChangeDictionary(this.dictionary);


 final  Locale dictionary;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameChangeDictionary&&(identical(other.dictionary, dictionary) || other.dictionary == dictionary));
}


@override
int get hashCode => Object.hash(runtimeType,dictionary);

@override
String toString() {
  return 'GameEvent.changeDictionary(dictionary: $dictionary)';
}


}




/// @nodoc


class _GameChangeGameMode implements GameEvent {
  const _GameChangeGameMode(this.gameMode);


 final  GameMode gameMode;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameChangeGameMode&&(identical(other.gameMode, gameMode) || other.gameMode == gameMode));
}


@override
int get hashCode => Object.hash(runtimeType,gameMode);

@override
String toString() {
  return 'GameEvent.changeGameMode(gameMode: $gameMode)';
}


}




/// @nodoc


class _GameResetBoard implements GameEvent {
  const _GameResetBoard(this.gameMode);


 final  GameMode gameMode;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameResetBoard&&(identical(other.gameMode, gameMode) || other.gameMode == gameMode));
}


@override
int get hashCode => Object.hash(runtimeType,gameMode);

@override
String toString() {
  return 'GameEvent.resetBoard(gameMode: $gameMode)';
}


}




/// @nodoc


class _GameLetterPressed implements GameEvent {
  const _GameLetterPressed(this.key);


 final  String key;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameLetterPressed&&(identical(other.key, key) || other.key == key));
}


@override
int get hashCode => Object.hash(runtimeType,key);

@override
String toString() {
  return 'GameEvent.letterPressed(key: $key)';
}


}




/// @nodoc


class _GameDeletePressed implements GameEvent {
  const _GameDeletePressed();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameDeletePressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameEvent.deletePressed()';
}


}




/// @nodoc


class _GameDeleteLongPressed implements GameEvent {
  const _GameDeleteLongPressed();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameDeleteLongPressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameEvent.deleteLongPressed()';
}


}




/// @nodoc


class _GameEnterPressed implements GameEvent {
  const _GameEnterPressed();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameEnterPressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameEvent.enterPressed()';
}


}




/// @nodoc


class _GameRetryLevelPersistence implements GameEvent {
  const _GameRetryLevelPersistence();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameRetryLevelPersistence);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameEvent.retryLevelPersistence()';
}


}




/// @nodoc


class _GameListenKeyEvent implements GameEvent {
  const _GameListenKeyEvent(this.keyEvent);


 final  KeyEvent keyEvent;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameListenKeyEvent&&(identical(other.keyEvent, keyEvent) || other.keyEvent == keyEvent));
}


@override
int get hashCode => Object.hash(runtimeType,keyEvent);

@override
String toString() {
  return 'GameEvent.listenKeyEvent(keyEvent: $keyEvent)';
}


}




/// @nodoc
mixin _$GameState {

 Locale get dictionary; String get secretWord; GameMode get gameMode; bool get gameCompleted; List<LetterInfo> get board; Map<String, LetterStatus> get statuses; int? get lvlNumber;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameState&&(identical(other.dictionary, dictionary) || other.dictionary == dictionary)&&(identical(other.secretWord, secretWord) || other.secretWord == secretWord)&&(identical(other.gameMode, gameMode) || other.gameMode == gameMode)&&(identical(other.gameCompleted, gameCompleted) || other.gameCompleted == gameCompleted)&&const DeepCollectionEquality().equals(other.board, board)&&const DeepCollectionEquality().equals(other.statuses, statuses)&&(identical(other.lvlNumber, lvlNumber) || other.lvlNumber == lvlNumber));
}


@override
int get hashCode => Object.hash(runtimeType,dictionary,secretWord,gameMode,gameCompleted,const DeepCollectionEquality().hash(board),const DeepCollectionEquality().hash(statuses),lvlNumber);

@override
String toString() {
  return 'GameState(dictionary: $dictionary, secretWord: $secretWord, gameMode: $gameMode, gameCompleted: $gameCompleted, board: $board, statuses: $statuses, lvlNumber: $lvlNumber)';
}


}




/// Adds pattern-matching-related methods to [GameState].
extension GameStatePatterns on GameState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GameIdle value)?  idle,TResult Function( GameLoss value)?  loss,TResult Function( GameWin value)?  win,TResult Function( GameFailure value)?  failure,TResult Function( GamePersistenceFailure value)?  persistenceFailure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GameIdle() when idle != null:
return idle(_that);case GameLoss() when loss != null:
return loss(_that);case GameWin() when win != null:
return win(_that);case GameFailure() when failure != null:
return failure(_that);case GamePersistenceFailure() when persistenceFailure != null:
return persistenceFailure(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GameIdle value)  idle,required TResult Function( GameLoss value)  loss,required TResult Function( GameWin value)  win,required TResult Function( GameFailure value)  failure,required TResult Function( GamePersistenceFailure value)  persistenceFailure,}){
final _that = this;
switch (_that) {
case GameIdle():
return idle(_that);case GameLoss():
return loss(_that);case GameWin():
return win(_that);case GameFailure():
return failure(_that);case GamePersistenceFailure():
return persistenceFailure(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GameIdle value)?  idle,TResult? Function( GameLoss value)?  loss,TResult? Function( GameWin value)?  win,TResult? Function( GameFailure value)?  failure,TResult? Function( GamePersistenceFailure value)?  persistenceFailure,}){
final _that = this;
switch (_that) {
case GameIdle() when idle != null:
return idle(_that);case GameLoss() when loss != null:
return loss(_that);case GameWin() when win != null:
return win(_that);case GameFailure() when failure != null:
return failure(_that);case GamePersistenceFailure() when persistenceFailure != null:
return persistenceFailure(_that);case _:
  return null;

}
}

}

/// @nodoc


class GameIdle extends GameState {
  const GameIdle({required this.dictionary, required this.secretWord, required this.gameMode, required this.gameCompleted, required  List<LetterInfo> board, required  Map<String, LetterStatus> statuses, required this.lvlNumber}): _board = board,_statuses = statuses,super._();


@override final  Locale dictionary;
@override final  String secretWord;
@override final  GameMode gameMode;
@override final  bool gameCompleted;
 final  List<LetterInfo> _board;
@override List<LetterInfo> get board {
  if (_board is EqualUnmodifiableListView) return _board;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_board);
}

 final  Map<String, LetterStatus> _statuses;
@override Map<String, LetterStatus> get statuses {
  if (_statuses is EqualUnmodifiableMapView) return _statuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_statuses);
}

@override final  int? lvlNumber;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameIdle&&(identical(other.dictionary, dictionary) || other.dictionary == dictionary)&&(identical(other.secretWord, secretWord) || other.secretWord == secretWord)&&(identical(other.gameMode, gameMode) || other.gameMode == gameMode)&&(identical(other.gameCompleted, gameCompleted) || other.gameCompleted == gameCompleted)&&const DeepCollectionEquality().equals(other._board, _board)&&const DeepCollectionEquality().equals(other._statuses, _statuses)&&(identical(other.lvlNumber, lvlNumber) || other.lvlNumber == lvlNumber));
}


@override
int get hashCode => Object.hash(runtimeType,dictionary,secretWord,gameMode,gameCompleted,const DeepCollectionEquality().hash(_board),const DeepCollectionEquality().hash(_statuses),lvlNumber);

@override
String toString() {
  return 'GameState.idle(dictionary: $dictionary, secretWord: $secretWord, gameMode: $gameMode, gameCompleted: $gameCompleted, board: $board, statuses: $statuses, lvlNumber: $lvlNumber)';
}


}




/// @nodoc


class GameLoss extends GameState {
  const GameLoss({required this.dictionary, required this.secretWord, required this.gameMode, required this.gameCompleted, required  List<LetterInfo> board, required  Map<String, LetterStatus> statuses, required this.lvlNumber}): _board = board,_statuses = statuses,super._();


@override final  Locale dictionary;
@override final  String secretWord;
@override final  GameMode gameMode;
@override final  bool gameCompleted;
 final  List<LetterInfo> _board;
@override List<LetterInfo> get board {
  if (_board is EqualUnmodifiableListView) return _board;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_board);
}

 final  Map<String, LetterStatus> _statuses;
@override Map<String, LetterStatus> get statuses {
  if (_statuses is EqualUnmodifiableMapView) return _statuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_statuses);
}

@override final  int? lvlNumber;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameLoss&&(identical(other.dictionary, dictionary) || other.dictionary == dictionary)&&(identical(other.secretWord, secretWord) || other.secretWord == secretWord)&&(identical(other.gameMode, gameMode) || other.gameMode == gameMode)&&(identical(other.gameCompleted, gameCompleted) || other.gameCompleted == gameCompleted)&&const DeepCollectionEquality().equals(other._board, _board)&&const DeepCollectionEquality().equals(other._statuses, _statuses)&&(identical(other.lvlNumber, lvlNumber) || other.lvlNumber == lvlNumber));
}


@override
int get hashCode => Object.hash(runtimeType,dictionary,secretWord,gameMode,gameCompleted,const DeepCollectionEquality().hash(_board),const DeepCollectionEquality().hash(_statuses),lvlNumber);

@override
String toString() {
  return 'GameState.loss(dictionary: $dictionary, secretWord: $secretWord, gameMode: $gameMode, gameCompleted: $gameCompleted, board: $board, statuses: $statuses, lvlNumber: $lvlNumber)';
}


}




/// @nodoc


class GameWin extends GameState {
  const GameWin({required this.dictionary, required this.secretWord, required this.gameMode, required this.gameCompleted, required  List<LetterInfo> board, required  Map<String, LetterStatus> statuses, required this.lvlNumber}): _board = board,_statuses = statuses,super._();


@override final  Locale dictionary;
@override final  String secretWord;
@override final  GameMode gameMode;
@override final  bool gameCompleted;
 final  List<LetterInfo> _board;
@override List<LetterInfo> get board {
  if (_board is EqualUnmodifiableListView) return _board;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_board);
}

 final  Map<String, LetterStatus> _statuses;
@override Map<String, LetterStatus> get statuses {
  if (_statuses is EqualUnmodifiableMapView) return _statuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_statuses);
}

@override final  int? lvlNumber;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameWin&&(identical(other.dictionary, dictionary) || other.dictionary == dictionary)&&(identical(other.secretWord, secretWord) || other.secretWord == secretWord)&&(identical(other.gameMode, gameMode) || other.gameMode == gameMode)&&(identical(other.gameCompleted, gameCompleted) || other.gameCompleted == gameCompleted)&&const DeepCollectionEquality().equals(other._board, _board)&&const DeepCollectionEquality().equals(other._statuses, _statuses)&&(identical(other.lvlNumber, lvlNumber) || other.lvlNumber == lvlNumber));
}


@override
int get hashCode => Object.hash(runtimeType,dictionary,secretWord,gameMode,gameCompleted,const DeepCollectionEquality().hash(_board),const DeepCollectionEquality().hash(_statuses),lvlNumber);

@override
String toString() {
  return 'GameState.win(dictionary: $dictionary, secretWord: $secretWord, gameMode: $gameMode, gameCompleted: $gameCompleted, board: $board, statuses: $statuses, lvlNumber: $lvlNumber)';
}


}




/// @nodoc


class GameFailure extends GameState {
  const GameFailure({required this.dictionary, required this.secretWord, required this.gameMode, required this.gameCompleted, required  List<LetterInfo> board, required  Map<String, LetterStatus> statuses, required this.error, required this.lvlNumber}): _board = board,_statuses = statuses,super._();


@override final  Locale dictionary;
@override final  String secretWord;
@override final  GameMode gameMode;
@override final  bool gameCompleted;
 final  List<LetterInfo> _board;
@override List<LetterInfo> get board {
  if (_board is EqualUnmodifiableListView) return _board;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_board);
}

 final  Map<String, LetterStatus> _statuses;
@override Map<String, LetterStatus> get statuses {
  if (_statuses is EqualUnmodifiableMapView) return _statuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_statuses);
}

 final  WordError error;
@override final  int? lvlNumber;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameFailure&&(identical(other.dictionary, dictionary) || other.dictionary == dictionary)&&(identical(other.secretWord, secretWord) || other.secretWord == secretWord)&&(identical(other.gameMode, gameMode) || other.gameMode == gameMode)&&(identical(other.gameCompleted, gameCompleted) || other.gameCompleted == gameCompleted)&&const DeepCollectionEquality().equals(other._board, _board)&&const DeepCollectionEquality().equals(other._statuses, _statuses)&&(identical(other.error, error) || other.error == error)&&(identical(other.lvlNumber, lvlNumber) || other.lvlNumber == lvlNumber));
}


@override
int get hashCode => Object.hash(runtimeType,dictionary,secretWord,gameMode,gameCompleted,const DeepCollectionEquality().hash(_board),const DeepCollectionEquality().hash(_statuses),error,lvlNumber);

@override
String toString() {
  return 'GameState.failure(dictionary: $dictionary, secretWord: $secretWord, gameMode: $gameMode, gameCompleted: $gameCompleted, board: $board, statuses: $statuses, error: $error, lvlNumber: $lvlNumber)';
}


}




/// @nodoc


class GamePersistenceFailure extends GameState {
  const GamePersistenceFailure({required this.dictionary, required this.secretWord, required this.gameMode, required this.gameCompleted, required  List<LetterInfo> board, required  Map<String, LetterStatus> statuses, required this.lvlNumber, required this.operation, required this.pendingProgress, required this.completedLevel, required this.pendingIsWin, required this.retryCount}): _board = board,_statuses = statuses,super._();


@override final  Locale dictionary;
@override final  String secretWord;
@override final  GameMode gameMode;
@override final  bool gameCompleted;
 final  List<LetterInfo> _board;
@override List<LetterInfo> get board {
  if (_board is EqualUnmodifiableListView) return _board;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_board);
}

 final  Map<String, LetterStatus> _statuses;
@override Map<String, LetterStatus> get statuses {
  if (_statuses is EqualUnmodifiableMapView) return _statuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_statuses);
}

@override final  int? lvlNumber;
 final  GamePersistenceOperation operation;
 final  GameResult pendingProgress;
 final  GameResult? completedLevel;
 final  bool? pendingIsWin;
 final  int retryCount;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GamePersistenceFailure&&(identical(other.dictionary, dictionary) || other.dictionary == dictionary)&&(identical(other.secretWord, secretWord) || other.secretWord == secretWord)&&(identical(other.gameMode, gameMode) || other.gameMode == gameMode)&&(identical(other.gameCompleted, gameCompleted) || other.gameCompleted == gameCompleted)&&const DeepCollectionEquality().equals(other._board, _board)&&const DeepCollectionEquality().equals(other._statuses, _statuses)&&(identical(other.lvlNumber, lvlNumber) || other.lvlNumber == lvlNumber)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.pendingProgress, pendingProgress) || other.pendingProgress == pendingProgress)&&(identical(other.completedLevel, completedLevel) || other.completedLevel == completedLevel)&&(identical(other.pendingIsWin, pendingIsWin) || other.pendingIsWin == pendingIsWin)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount));
}


@override
int get hashCode => Object.hash(runtimeType,dictionary,secretWord,gameMode,gameCompleted,const DeepCollectionEquality().hash(_board),const DeepCollectionEquality().hash(_statuses),lvlNumber,operation,pendingProgress,completedLevel,pendingIsWin,retryCount);

@override
String toString() {
  return 'GameState.persistenceFailure(dictionary: $dictionary, secretWord: $secretWord, gameMode: $gameMode, gameCompleted: $gameCompleted, board: $board, statuses: $statuses, lvlNumber: $lvlNumber, operation: $operation, pendingProgress: $pendingProgress, completedLevel: $completedLevel, pendingIsWin: $pendingIsWin, retryCount: $retryCount)';
}


}




// dart format on
