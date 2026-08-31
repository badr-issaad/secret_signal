enum GameRole {
  host,
  agent,
  seeker,
}

extension GameRoleExtension on GameRole {
  String get displayName {
    switch (this) {
      case GameRole.host:
        return 'HOST';
      case GameRole.agent:
        return 'AGENT';
      case GameRole.seeker:
        return 'SEEKER';
    }
  }
}
