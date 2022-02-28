import 'package:isar/isar.dart';

part 'daily_statistic_data.g.dart';

@Collection()
class DailyStatisticData {
  DailyStatisticData();

  factory DailyStatisticData.init(final int id) => DailyStatisticData()
    ..id = id
    ..winsNumber = 0
    ..losesNumber = 0
    ..currentStreak = 0
    ..attempts = List.generate(6, (index) => 0);

  @Id()
  int? id;
  late int winsNumber;
  late int losesNumber;
  late int currentStreak;
  late List<int> attempts;

  DailyStatisticData copyWith({
    int? winsNumber,
    int? losesNumber,
    int? currentStreak,
    List<int>? attempts,
  }) =>
      DailyStatisticData()
        ..winsNumber = winsNumber ?? this.winsNumber
        ..losesNumber = losesNumber ?? this.losesNumber
        ..currentStreak = currentStreak ?? this.currentStreak
        ..attempts = attempts ?? this.attempts;
}
