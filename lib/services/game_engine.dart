import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_settings.dart';
import '../models/game_session.dart';
import '../models/player.dart';
import '../models/role.dart';
import '../models/word_pack.dart';

class GameEngine extends StateNotifier<GameSession?> {
  GameEngine() : super(null);
  
  int _currentRevealIndex = 0;

  void startGame(GameSettings settings, List<Player> players, WordPack pack) {
    // Randomly select a word
    final random = Random();
    final word = pack.words[random.nextInt(pack.words.length)];

    // Assign roles randomly
    final shuffledPlayers = List<Player>.from(players)..shuffle(random);
    
    final roles = <String, GameRole>{};
    roles[shuffledPlayers[0].id] = GameRole.host;
    roles[shuffledPlayers[1].id] = GameRole.agent;
    
    for (int i = 2; i < shuffledPlayers.length; i++) {
      roles[shuffledPlayers[i].id] = GameRole.seeker;
    }

    _currentRevealIndex = 0;

    state = GameSession(
      players: players,
      playerRoles: roles,
      secretWord: word.word,
      wordPack: pack,
      settings: settings,
      currentPhase: GamePhase.roleReveal,
    );
  }
  
  Player? getCurrentRevealPlayer() {
    if (state == null || _currentRevealIndex >= state!.players.length) return null;
    return state!.players[_currentRevealIndex];
  }
  
  void nextRevealPlayer() {
    if (state == null) return;
    
    _currentRevealIndex++;
    if (_currentRevealIndex >= state!.players.length) {
      // Everyone has seen their role, move to question round
      setPhase(GamePhase.questionRound);
    } else {
      // Force state update to rebuild UI
      state = state!.copyWith();
    }
  }

  void setPhase(GamePhase phase) {
    if (state != null) {
      state = state!.copyWith(currentPhase: phase);
    }
  }

  void markAnswerFound() {
    setPhase(GamePhase.guesserSelection);
  }

  void setGuesser(String playerId) {
    if (state != null) {
      state = state!.copyWith(
        guesserId: playerId,
        currentPhase: GamePhase.wordReveal,
      );
    }
  }

  void handleTimeUp() {
    if (state != null && state!.currentPhase == GamePhase.questionRound) {
      // Seekers lose immediately
      final agentId = state!.playerRoles.entries.firstWhere((e) => e.value == GameRole.agent).key;
      
      // Update agent score
      final updatedPlayers = state!.players.map((p) {
        if (p.id == agentId) {
          return p.copyWith(score: p.score + 200);
        }
        return p;
      }).toList();

      state = state!.copyWith(
        currentPhase: GamePhase.result,
        winners: [agentId],
        agentEscaped: true,
        players: updatedPlayers,
      );
    }
  }

  void startDiscussion() {
    setPhase(GamePhase.discussion);
  }

  void startVoting() {
    if (state == null) return;
    _currentRevealIndex = 0;
    setPhase(GamePhase.voting);
  }

  void castVote(String accusedId) {
    if (state == null) return;
    final voter = getCurrentRevealPlayer();
    if (voter == null) return;

    final newVotes = Map<String, String>.from(state!.votes);
    newVotes[voter.id] = accusedId;
    
    state = state!.copyWith(votes: newVotes);

    _currentRevealIndex++;
    if (_currentRevealIndex >= state!.players.length) {
      _calculateVotingResults();
    } else {
      // Force UI rebuild for the next player
      state = state!.copyWith();
    }
  }

  void _calculateVotingResults() {
    if (state == null) return;

    final voteCounts = <String, int>{};
    for (final accusedId in state!.votes.values) {
      voteCounts[accusedId] = (voteCounts[accusedId] ?? 0) + 1;
    }

    if (voteCounts.isEmpty) return;

    // Find the player(s) with the most votes
    int maxVotes = 0;
    for (final count in voteCounts.values) {
      if (count > maxVotes) maxVotes = count;
    }

    final topVoted = voteCounts.entries
        .where((e) => e.value == maxVotes)
        .map((e) => e.key)
        .toList();

    String? accusedId;
    bool agentEscaped = false;
    List<String> winners = [];

    final agentId = state!.playerRoles.entries.firstWhere((e) => e.value == GameRole.agent).key;

    if (topVoted.length == 1) {
      accusedId = topVoted.first;
      if (accusedId == agentId) {
        // Seekers + Host win
        winners = state!.players
            .where((p) => state!.playerRoles[p.id] != GameRole.agent)
            .map((p) => p.id)
            .toList();
      } else {
        // Agent wins
        winners = [agentId];
        agentEscaped = true;
      }
    } else {
      // Tie -> Agent escapes
      agentEscaped = true;
      winners = [agentId];
    }

    // Assign points
    final updatedPlayers = state!.players.map((p) {
      int pointsToAdd = 0;
      if (winners.contains(p.id)) {
        if (p.id == agentId) {
          pointsToAdd += 200; // Agent wins
        } else {
          pointsToAdd += 100; // Seekers/Host win
        }
      }
      
      // Guesser bonus
      if (p.id == state!.guesserId) {
        pointsToAdd += 50;
      }

      return p.copyWith(score: p.score + pointsToAdd);
    }).toList();

    state = state!.copyWith(
      currentPhase: GamePhase.result,
      accusedId: accusedId,
      agentEscaped: agentEscaped,
      winners: winners,
      players: updatedPlayers,
    );
  }

  void nextRound() {
    if (state == null) return;
    
    // Carry over updated players and settings
    final players = List<Player>.from(state!.players);
    final settings = state!.settings;
    final currentPack = state!.wordPack;
    
    // Reset state, but don't clear completely, just restart game
    startGame(settings, players, currentPack);
  }

  void resetGame() {
    state = null;
  }
}

final gameEngineProvider = StateNotifierProvider<GameEngine, GameSession?>((ref) {
  return GameEngine();
});
