import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/primary_button.dart';
import '../widgets/role_icon.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              const RoleIcon(
                icon: Icons.mobile_screen_share,
                color: AppColors.accent,
                size: 100,
              ),
              const SizedBox(height: 48),
              Text(
                'Pass the phone\nto ',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.3,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                currentPlayer.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.lightAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(flex: 4),
              PrimaryButton(
                text: "I'm Ready",
                onPressed: () {
                  if (gameSession.currentPhase == GamePhase.roleReveal) {
                    context.push('/role_reveal');
                  } else if (gameSession.currentPhase == GamePhase.voting) {
                    context.push('/voting');
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                "Don't show names or roles.\nJust pass it.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textDisabled,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
