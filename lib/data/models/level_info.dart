class LevelInfo {
  LevelInfo({required this.lastCompletedLevel, required this.isGameComplete});

  factory LevelInfo.fromJson(Map<String, dynamic> json) => LevelInfo(
        lastCompletedLevel: json['lastCompletedLevel'] as int,
        isGameComplete: json['isGameComplete'] as bool,
      );

  final int lastCompletedLevel;
  final bool isGameComplete;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'lastCompletedLevel': lastCompletedLevel,
        'isGameComplete': isGameComplete,
      };
}
