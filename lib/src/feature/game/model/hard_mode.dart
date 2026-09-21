import 'package:wordly/src/feature/game/model/letter_info.dart';
import 'package:wordly/src/feature/game/model/word_error.dart';

// Green positions and revealed letter counts carry forward; gray letters impose no constraint.
WordError? validateHardMode(List<LetterInfo> revealedBoard, List<String> guess) {
  if (guess.isEmpty) {
    return WordError.tooShort;
  }
  final counts = <String, int>{};
  for (final letter in guess) {
    counts.update(letter, (count) => count + 1, ifAbsent: () => 1);
  }
  // Count repeats within each guess, never across guesses showing the same hint.
  for (var start = 0; start + guess.length <= revealedBoard.length; start += guess.length) {
    final requiredCounts = <String, int>{};
    for (var position = 0; position < guess.length; position++) {
      final LetterInfo hint = revealedBoard[start + position];
      if (hint.status == LetterStatus.correctSpot && guess[position] != hint.letter) {
        return WordError.hardModePosition;
      }
      if (hint.status == LetterStatus.correctSpot || hint.status == LetterStatus.wrongSpot) {
        requiredCounts.update(hint.letter, (count) => count + 1, ifAbsent: () => 1);
      }
    }
    for (final MapEntry<String, int> entry in requiredCounts.entries) {
      if ((counts[entry.key] ?? 0) < entry.value) {
        return WordError.hardModeMissingLetters;
      }
    }
  }
  return null;
}
