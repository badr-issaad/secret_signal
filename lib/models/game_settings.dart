class GameSettings {
  final int playerCount;
  final Duration questionTime;
  final Duration discussionTime;
  final String selectedPackId;

  const GameSettings({
    this.playerCount = 6,
    this.questionTime = const Duration(minutes: 5),
    this.discussionTime = const Duration(minutes: 2),
    this.selectedPackId = 'everyday',
  });

  GameSettings copyWith({
    int? playerCount,
    Duration? questionTime,
    Duration? discussionTime,
    String? selectedPackId,
  }) {
    return GameSettings(
      playerCount: playerCount ?? this.playerCount,
      questionTime: questionTime ?? this.questionTime,
      discussionTime: discussionTime ?? this.discussionTime,
      selectedPackId: selectedPackId ?? this.selectedPackId,
    );
  }
}
