import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_card.dart';
import '../theme/colors.dart';
import '../services/game_engine.dart';

class ScoreboardScreen extends ConsumerWidget {
  const ScoreboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(gameEngineProvider);
    final engine = ref.read(gameEngineProvider.notifier);

    if (session == null) return const Scaffold();

    // Sort players by score descending
    final sortedPlayers = List.of(session.players)
      ..sort((a, b) => b.score.compareTo(a.score));

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'SCOREBOARD',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: sortedPlayers.length,
                  itemBuilder: (context, index) {
                    final player = sortedPlayers[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: AppCard(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '#${index + 1}',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.accent,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  player.name,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${player.score} pts',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Play Next Round',
                onPressed: () {
                  engine.nextRound();
                  context.go('/pass_phone');
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  engine.resetGame();
                  context.go('/');
                },
                child: const Text('End Game', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

