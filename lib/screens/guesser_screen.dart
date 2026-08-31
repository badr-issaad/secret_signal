import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/colors.dart';
import '../services/game_engine.dart';
import '../models/role.dart';
import '../widgets/app_card.dart';

class GuesserScreen extends ConsumerWidget {
  const GuesserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(gameEngineProvider);
    final engine = ref.read(gameEngineProvider.notifier);

    if (session == null) return const Scaffold();

    // Host cannot be the guesser
    final eligiblePlayers = session.players.where((p) => session.playerRoles[p.id] != GameRole.host).toList();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'WHO FOUND IT?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Select the player who correctly guessed the secret word.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
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
                          engine.setGuesser(player.id);
                          context.push('/word_reveal');
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
}

