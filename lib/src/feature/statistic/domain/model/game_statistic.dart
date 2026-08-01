import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

@immutable
class GameStatistic {
  const GameStatistic({
    required this.wins,
    required this.loses,
    required this.streak,
    required this.maxStreak,
    required this.attempts,
    this.version = currentVersion,
  });

  static const int currentVersion = 2;
  final int version;
  final int wins;
  final int loses;
  final int streak;
  final int maxStreak;
  final List<int> attempts;

  static const zeroAttempts = <int>[0, 0, 0, 0, 0, 0];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameStatistic &&
          runtimeType == other.runtimeType &&
          version == other.version &&
          wins == other.wins &&
          loses == other.loses &&
          streak == other.streak &&
          maxStreak == other.maxStreak &&
          const DeepCollectionEquality().equals(attempts, other.attempts);

  @override
  int get hashCode =>
      Object.hash(version, wins, loses, streak, maxStreak, const DeepCollectionEquality().hash(attempts));
}
