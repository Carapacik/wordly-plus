import 'package:meta/meta.dart';

@immutable
final class LevelResult {
  const LevelResult({required this.levelNumber, required this.secretWord, required this.isWin});

  const LevelResult.unavailable({required this.levelNumber}) : secretWord = null, isWin = null;

  final int levelNumber;
  final String? secretWord;
  final bool? isWin;

  bool get isUnavailable => secretWord == null && isWin == null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelResult &&
          runtimeType == other.runtimeType &&
          levelNumber == other.levelNumber &&
          secretWord == other.secretWord &&
          isWin == other.isWin;

  @override
  int get hashCode => Object.hash(levelNumber, secretWord, isWin);
}
