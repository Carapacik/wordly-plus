import 'package:flutter_test/flutter_test.dart';
import 'package:wordly/src/feature/game/data/dictionary/word_schedule.dart';

void main() {
  test('daily uses UTC dates, including dates before the epoch and offset timestamps', () {
    final schedule = WordSchedule(levels: ['rare', 'plain'], daily: ['first', 'second', 'third']);
    expect(schedule.daily(DateTime.utc(2026, 9)), 'first');
    expect(schedule.daily(DateTime.utc(2026, 8, 31, 23, 59, 59)), 'third');
    expect(schedule.daily(DateTime.parse('2026-09-02T02:59:59+03:00')), 'first');
    expect(schedule.daily(DateTime.parse('2026-09-02T03:00:00+03:00')), 'second');
    expect(schedule.daily(DateTime.utc(2026, 9, 4)), 'first');
    // Fixed independent vectors: 122 and 123 UTC days after the epoch.
    expect(schedule.daily(DateTime.utc(2027)), 'third');
    expect(schedule.daily(DateTime.utc(2027, 1, 2)), 'first');
    expect(schedule.daily(DateTime.utc(2028, 2, 28)), 'third');
    expect(schedule.daily(DateTime.utc(2028, 2, 29)), 'first');
    expect(schedule.daily(DateTime.utc(2028, 3)), 'second');
  });

  test('levels use their full frozen order, independently of daily and caller mutations', () {
    final levels = ['rare', 'plain', 'other'];
    final daily = ['plain'];
    final schedule = WordSchedule(levels: levels, daily: daily);
    levels
      ..clear()
      ..add('new-word');
    daily.add('other');
    expect(
      [for (var i = 1; i <= 7; i++) schedule.level(i)],
      ['rare', 'plain', 'other', 'rare', 'plain', 'other', 'rare'],
    );
    expect(schedule.daily(DateTime.utc(2026, 9, 22)), 'plain');
    expect(() => schedule.level(0), throwsRangeError);
    expect(() => schedule.level(-1), throwsRangeError);
    expect(() => WordSchedule(levels: [], daily: ['plain']), throwsArgumentError);
    expect(() => WordSchedule(levels: ['plain'], daily: []), throwsArgumentError);
  });
}
