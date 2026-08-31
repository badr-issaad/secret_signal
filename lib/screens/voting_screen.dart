import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/colors.dart';
import '../services/game_engine.dart';
import '../models/game_session.dart';
import '../widgets/app_card.dart';

class VotingScreen extends ConsumerWidget {
  const VotingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(gameEngineProvider);
    final engine = ref.read(gameEngineProvider.notifier);

    if (session == null) return const Scaffold();

    final currentPlayer = engine.getCurrentRevealPlayer();
    if (currentPlayer == null) return const Scaffold();

    // The current player shouldn't vote for themselves
    final eligiblePlayers = session.players.where((p) => p.id != currentPlayer.id).toList();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'VOTE',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'WHO IS THE AGENT?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.agentAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Privately cast your vote.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Expanded(
                child: ListView.builder(
                  itemCount: eligiblePlayers.length,
                  itemBuilder: (context, index) {
                    final player = eligiblePlayers[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: InkWell(
                        onTap: () {
                          _showConfirmationDialog(context, engine, player.id, player.name, ref);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: AppCard(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            player.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, GameEngine engine, String accusedId, String accusedName, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.elevatedSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Lock Vote?',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to vote for $accusedName?',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              engine.castVote(accusedId);
              
              final currentPhase = ref.read(gameEngineProvider)!.currentPhase;
              if (currentPhase == GamePhase.result) {
                context.go('/result');
              } else {
                context.pop(); // Go back to pass phone screen
              }
            },
            child: const Text('Lock Vote', style: TextStyle(color: AppColors.agentAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

