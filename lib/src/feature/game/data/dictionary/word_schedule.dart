/// Immutable answers-v2 positions, exported inside each dictionary database.
/// Definitions and allowed guesses are deliberately not inputs to selection.
final class WordSchedule({required List<String> levels, required List<String> daily}) {
  this {
    if (_levels.isEmpty || _daily.isEmpty) {
      throw ArgumentError('Answer schedules must not be empty');
    }
  }

  static const String version = 'answers-v2';
  static final DateTime epoch = DateTime.utc(2026, 9);
  final List<String> _levels = List.unmodifiable(levels);
  final List<String> _daily = List.unmodifiable(daily);

  String level(int number) {
    if (number < 1) {
      throw RangeError.range(number, 1, null, 'number');
    }
    return _levels[(number - 1) % _levels.length];
  }

  String daily(DateTime instant) {
    final DateTime utc = instant.toUtc();
    final int day = DateTime.utc(utc.year, utc.month, utc.day).difference(epoch).inDays;
    return _daily[day % _daily.length];
  }
}
