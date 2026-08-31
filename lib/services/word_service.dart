import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/word_pack.dart';

class WordService {
  Future<List<WordPack>> loadWordPacks() async {
    final List<WordPack> packs = [];
    
    // In a real scenario, we might use a manifest or list, 
    // but for now we know the exact paths we created.
    final packFiles = [
      'assets/data/word_packs/everyday.json',
      'assets/data/word_packs/animals.json',
      'assets/data/word_packs/food.json',
    ];

    for (final path in packFiles) {
      try {
        final jsonString = await rootBundle.loadString(path);
        final jsonMap = jsonDecode(jsonString);
        packs.add(WordPack.fromJson(jsonMap));
      } catch (e) {
        // Ignore missing or malformed packs for now
        debugPrint('Error loading word pack $path: $e');
      }
    }
    
    return packs;
  }
}

final wordServiceProvider = Provider<WordService>((ref) {
  return WordService();
});

final wordPacksProvider = FutureProvider<List<WordPack>>((ref) async {
  final service = ref.watch(wordServiceProvider);
  return await service.loadWordPacks();
});
