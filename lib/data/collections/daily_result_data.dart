import 'package:isar/isar.dart';

part 'daily_result_data.g.dart';

@Collection()
class DailyResultData {
  DailyResultData();

  factory DailyResultData.init(final int id) => DailyResultData()
    ..id = id
    ..dailyWord = ''
    ..isWin = false;

  @Id()
  late int id;
  late String dailyWord;
  late bool isWin;
}
