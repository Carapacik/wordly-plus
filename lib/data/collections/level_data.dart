import 'package:isar/isar.dart';

part 'level_data.g.dart';

@Collection()
class LevelData {
  LevelData();

  factory LevelData.init(final int id) => LevelData()
    ..id = id
    ..lastLevel = 1;

  @Id()
  late int id;
  late int lastLevel;
}
