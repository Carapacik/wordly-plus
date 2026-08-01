import 'package:wordly/src/core/common/common.dart';
import 'package:wordly/src/feature/statistic/domain/model/game_statistic.dart';

class StatisticCodec extends JsonMapCodec<GameStatistic> {
  const StatisticCodec();

  @override
  GameStatistic $decode(Map<String, Object?> input) {
    final wins = input['wins']! as int;
    final loses = input['loses']! as int;
    final streak = input['streak']! as int;
    final maxStreak = input['maxStreak']! as int;
    final List<int> attempts = (input['attempts']! as List<dynamic>).map((e) => e as int).toList();

    return GameStatistic(
      version: input['version'] as int? ?? 1,
      wins: wins,
      loses: loses,
      streak: streak,
      maxStreak: maxStreak,
      attempts: attempts,
    );
  }

  @override
  Map<String, Object?> $encode(GameStatistic input) => {
    'version': GameStatistic.currentVersion,
    'wins': input.wins,
    'loses': input.loses,
    'streak': input.streak,
    'maxStreak': input.maxStreak,
    'attempts': input.attempts,
  };
}
