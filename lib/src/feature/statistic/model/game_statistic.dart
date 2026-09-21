import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

@immutable
class const GameStatistic({
  required final int wins,
  required final int loses,
  required final int streak,
  required final int maxStreak,
  required final List<int> attempts,
  final int version = currentVersion,
}) {
  static const int currentVersion = 2;
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
