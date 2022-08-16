class GameResult {
  const GameResult({required this.word, required this.meaning, this.isWin});

  factory GameResult.fromJson(Map<String, dynamic> json) => GameResult(
        word: json['word'] as String,
        meaning: json['meaning'] as String,
        isWin: json['isWin'] as bool?,
      );

  final String word;
  final String meaning;
  final bool? isWin;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'word': word,
        'meaning': meaning,
        'isWin': isWin,
      };
}
