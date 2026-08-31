import 'word.dart';

class WordPack {
  final String id;
  final String name;
  final List<Word> words;

  const WordPack({
    required this.id,
    required this.name,
    required this.words,
  });

  factory WordPack.fromJson(Map<String, dynamic> json) {
    var wordsJson = json['words'] as List;
    List<Word> wordsList = wordsJson.map((w) => Word.fromJson(w as Map<String, dynamic>)).toList();

    return WordPack(
      id: json['id'] as String,
      name: json['name'] as String,
      words: wordsList,
    );
  }
}
