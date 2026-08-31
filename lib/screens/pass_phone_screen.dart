import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/primary_button.dart';
import '../theme/colors.dart';
import '../services/game_engine.dart';
import '../models/game_session.dart';

class PassPhoneScreen extends ConsumerWidget {
  const PassPhoneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameSession = ref.watch(gameEngineProvider);
    final engine = ref.read(gameEngineProvider.notifier);
    
    // Safety check
    if (gameSession == null || 
        (gameSession.currentPhase != GamePhase.roleReveal && 
         gameSession.currentPhase != GamePhase.voting)) {
      return const Scaffold(body: Center(child: Text('Invalid State')));
    }

    final currentPlayer = engine.getCurrentRevealPlayer();
    if (currentPlayer == null) {
      return const Scaffold(body: Center(child: Text('No player found')));
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'PASS THE PHONE',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'TO',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                currentPlayer.name.toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.accent,
                ),
              ),
              const Spacer(),
              PrimaryButton(
                text: "I'M READY",
                onPressed: () {
                  if (gameSession.currentPhase == GamePhase.roleReveal) {
                    context.push('/role_reveal');
                  } else if (gameSession.currentPhase == GamePhase.voting) {
                    context.push('/voting');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
