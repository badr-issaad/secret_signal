import 'player.dart';
import 'role.dart';
import 'game_settings.dart';
import 'word_pack.dart';

enum GamePhase {
  setup,
  roleReveal,
  questionRound,
  guesserSelection,
  wordReveal,
  discussion,
  voting,
  result,
  scoreboard,
}

class GameSession {
  final List<Player> players;
  final Map<String, GameRole> playerRoles; // Player ID -> Role
  final String secretWord;
  final WordPack wordPack;
  final GameSettings settings;
  final GamePhase currentPhase;
  final String? guesserId;
  final Map<String, String> votes; // voterId -> accusedId
  final List<String> winners; // list of player IDs who won
  final String? accusedId; // The player who was accused by the group
  final bool agentEscaped;

  const GameSession({
    required this.players,
    required this.playerRoles,
    required this.secretWord,
    required this.wordPack,
    required this.settings,
    this.currentPhase = GamePhase.setup,
    this.guesserId,
    this.votes = const {},
    this.winners = const [],
    this.accusedId,
    this.agentEscaped = false,
  });

  GameSession copyWith({
    List<Player>? players,
    Map<String, GameRole>? playerRoles,
    String? secretWord,
    WordPack? wordPack,
    GameSettings? settings,
    GamePhase? currentPhase,
    String? guesserId,
    Map<String, String>? votes,
    List<String>? winners,
    String? accusedId,
    bool? agentEscaped,
  }) {
    return GameSession(
      players: players ?? this.players,
      playerRoles: playerRoles ?? this.playerRoles,
      secretWord: secretWord ?? this.secretWord,
      wordPack: wordPack ?? this.wordPack,
      settings: settings ?? this.settings,
      currentPhase: currentPhase ?? this.currentPhase,
      guesserId: guesserId ?? this.guesserId,
      votes: votes ?? this.votes,
      winners: winners ?? this.winners,
      accusedId: accusedId ?? this.accusedId,
      agentEscaped: agentEscaped ?? this.agentEscaped,
    );
  }
}
