import 'package:flutter_test/flutter_test.dart';
import 'package:secret_signal/models/game_session.dart';
import 'package:secret_signal/models/game_settings.dart';
import 'package:secret_signal/models/player.dart';
import 'package:secret_signal/models/role.dart';
import 'package:secret_signal/models/word.dart';
import 'package:secret_signal/models/word_pack.dart';
import 'package:secret_signal/services/game_engine.dart';

void main() {
  group('GameEngine logic', () {
    test('startGame assigns exactly 1 Host, 1 Agent, and remaining Seekers', () {
      final engine = GameEngine();
      final players = [
        const Player(id: '1', name: 'Alice'),
        const Player(id: '2', name: 'Bob'),
        const Player(id: '3', name: 'Charlie'),
        const Player(id: '4', name: 'Diana'),
        const Player(id: '5', name: 'Eve'),
        const Player(id: '6', name: 'Frank'),
      ];
      
      final pack = WordPack(id: 'test', name: 'Test', words: [
        const Word(word: 'Apple', difficulty: 'easy', category: 'food'),
      ]);
      
      engine.startGame(const GameSettings(playerCount: 6), players, pack);
      
      final session = engine.state;
      expect(session, isNotNull);
      
      int hostCount = 0;
      int agentCount = 0;
      int seekerCount = 0;
      
      for (final role in session!.playerRoles.values) {
        if (role == GameRole.host) hostCount++;
        if (role == GameRole.agent) agentCount++;
        if (role == GameRole.seeker) seekerCount++;
      }
      
      expect(hostCount, 1);
      expect(agentCount, 1);
      expect(seekerCount, 4);
    });

    test('Agent and Host receive the exact same secret word, Seekers do not get distinct words (the state handles this globally but we can verify the session has it)', () {
      final engine = GameEngine();
      final players = [
        const Player(id: '1', name: 'Alice'),
        const Player(id: '2', name: 'Bob'),
        const Player(id: '3', name: 'Charlie'),
        const Player(id: '4', name: 'Diana'),
      ];
      
      final pack = WordPack(id: 'test', name: 'Test', words: [
        const Word(word: 'Banana', difficulty: 'easy', category: 'food'),
      ]);
      
      engine.startGame(const GameSettings(playerCount: 4), players, pack);
      final session = engine.state;
      
      expect(session!.secretWord, 'Banana');
    });

    test('markAnswerFound and setGuesser correctly update phase and guesserId', () {
      final engine = GameEngine();
      final players = [
        const Player(id: '1', name: 'Alice'),
        const Player(id: '2', name: 'Bob'),
        const Player(id: '3', name: 'Charlie'),
        const Player(id: '4', name: 'Diana'),
      ];
      final pack = WordPack(id: 'test', name: 'Test', words: [
        const Word(word: 'Apple', difficulty: 'easy', category: 'food'),
      ]);

      engine.startGame(const GameSettings(playerCount: 4), players, pack);
      
      engine.markAnswerFound();
      expect(engine.state!.currentPhase, GamePhase.guesserSelection);

      engine.setGuesser('3');
      expect(engine.state!.guesserId, '3');
      expect(engine.state!.currentPhase, GamePhase.wordReveal);

      engine.startDiscussion();
      expect(engine.state!.currentPhase, GamePhase.discussion);
    });

    test('Voting correctly tallies and identifies winner when Agent is caught', () {
      final engine = GameEngine();
      final players = [
        const Player(id: '1', name: 'Alice'),
        const Player(id: '2', name: 'Bob'),
        const Player(id: '3', name: 'Charlie'),
        const Player(id: '4', name: 'Diana'),
      ];
      final pack = WordPack(id: 'test', name: 'Test', words: [
        const Word(word: 'Apple', difficulty: 'easy', category: 'food'),
      ]);

      engine.startGame(const GameSettings(playerCount: 4), players, pack);
      
      // Let's find out who the agent is
      final agentId = engine.state!.playerRoles.entries.firstWhere((e) => e.value == GameRole.agent).key;
      final nonAgentId = engine.state!.playerRoles.entries.firstWhere((e) => e.value != GameRole.agent).key;
      
      engine.startVoting();
      
      // Cast 3 votes for agent, 1 vote for someone else
      engine.castVote(agentId);
      engine.castVote(agentId);
      engine.castVote(agentId);
      engine.castVote(nonAgentId);
      
      expect(engine.state!.currentPhase, GamePhase.result);
      expect(engine.state!.accusedId, agentId);
      expect(engine.state!.agentEscaped, false);
      expect(engine.state!.winners.contains(agentId), false); // Agent didn't win

      // Verify scoring: Seekers win (+100)
      final alice = engine.state!.players.firstWhere((p) => p.name == 'Alice');
      // If Alice is a Seeker, she gets 100 points
      if (engine.state!.playerRoles[alice.id] != GameRole.agent) {
        expect(alice.score, 100);
      }
    });

    test('nextRound preserves player scores and resets state', () {
      final engine = GameEngine();
      final players = [
        const Player(id: '1', name: 'Alice', score: 100), // Previous score
        const Player(id: '2', name: 'Bob', score: 200),
      ];
      final pack = WordPack(id: 'test', name: 'Test', words: [
        const Word(word: 'Apple', difficulty: 'easy', category: 'food'),
      ]);

      engine.startGame(const GameSettings(playerCount: 2), players, pack);
      
      engine.nextRound();
      
      expect(engine.state!.currentPhase, GamePhase.roleReveal);
      expect(engine.state!.players.firstWhere((p) => p.name == 'Alice').score, 100);
      expect(engine.state!.players.firstWhere((p) => p.name == 'Bob').score, 200);
      expect(engine.state!.votes, isEmpty);
    });
  });
}
