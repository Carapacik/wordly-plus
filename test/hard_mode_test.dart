import 'package:flutter_test/flutter_test.dart';
import 'package:wordly/src/feature/game/model/hard_mode.dart';
import 'package:wordly/src/feature/game/model/letter_info.dart';
import 'package:wordly/src/feature/game/model/word_error.dart';

List<LetterInfo> row(String word, String hints) => [
  for (var i = 0; i < word.length; i++)
    LetterInfo(
      letter: word[i],
      status: switch (hints[i]) {
        'g' => LetterStatus.correctSpot,
        'y' => LetterStatus.wrongSpot,
        _ => LetterStatus.notInWord,
      },
    ),
];

void main() {
  test('first guess is unrestricted', () {
    expect(validateHardMode([], 'crane'.split('')), isNull);
  });

  test('green letters must stay in place', () {
    expect(validateHardMode(row('arise', 'g---g'), 'crane'.split('')), WordError.hardModePosition);
    expect(validateHardMode(row('arise', 'g---g'), 'apple'.split('')), isNull);
  });

  test('yellow letters are mandatory but their previous positions are allowed', () {
    final List<LetterInfo> board = row('cider', '---y-');
    expect(validateHardMode(board, 'crank'.split('')), WordError.hardModeMissingLetters);
    expect(validateHardMode(board, 'cider'.split('')), isNull);
    expect(validateHardMode(board, 'apple'.split('')), isNull);
  });

  test('green and yellow copies in one row both count; grey copies do not', () {
    final List<LetterInfo> board = row('poppy', 'yyg--');
    expect(validateHardMode(board, 'dopey'.split('')), WordError.hardModeMissingLetters);
    expect(validateHardMode(board, 'poppy'.split('')), isNull);
  });

  test('hints are retained across rows without adding duplicate counts', () {
    final List<LetterInfo> board = [...row('cider', '---y-'), ...row('eject', 'y----')];
    expect(validateHardMode(board, 'apple'.split('')), isNull);
    expect(validateHardMode(board, 'crank'.split('')), WordError.hardModeMissingLetters);
  });

  test('Russian letters use the same rules', () {
    expect(validateHardMode(row('маска', 'g--yg'), 'марка'.split('')), isNull);
    expect(validateHardMode(row('маска', 'g--yg'), 'манна'.split('')), WordError.hardModeMissingLetters);
  });
}
