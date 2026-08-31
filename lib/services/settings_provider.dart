import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_settings.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // Initialized in main.dart
});

class SettingsNotifier extends StateNotifier<GameSettings> {
  final SharedPreferences _prefs;

  SettingsNotifier(this._prefs) : super(const GameSettings(playerCount: 0)) {
    _loadSettings();
  }

  void _loadSettings() {
    final qTimeSeconds = _prefs.getInt('questionTimeSeconds');
    final dTimeSeconds = _prefs.getInt('discussionTimeSeconds');

    state = state.copyWith(
      questionTime: qTimeSeconds != null ? Duration(seconds: qTimeSeconds) : null,
      discussionTime: dTimeSeconds != null ? Duration(seconds: dTimeSeconds) : null,
    );
  }

  Future<void> updateQuestionTime(Duration duration) async {
    await _prefs.setInt('questionTimeSeconds', duration.inSeconds);
    state = state.copyWith(questionTime: duration);
  }

  Future<void> updateDiscussionTime(Duration duration) async {
    await _prefs.setInt('discussionTimeSeconds', duration.inSeconds);
    state = state.copyWith(discussionTime: duration);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, GameSettings>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsNotifier(prefs);
});
