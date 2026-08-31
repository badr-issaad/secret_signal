class Word {
  final String word;
  final String difficulty;
  final String category;

  const Word({
    required this.word,
    required this.difficulty,
    required this.category,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'] as String,
      difficulty: json['difficulty'] as String,
      category: json['category'] as String,
    );
  }
}
