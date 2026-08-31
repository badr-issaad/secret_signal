import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/primary_button.dart';
import '../widgets/countdown_timer.dart';
import '../theme/colors.dart';
import '../services/game_engine.dart';
import '../models/role.dart';

class QuestionRoundScreen extends ConsumerWidget {
  const QuestionRoundScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(gameEngineProvider);
    final engine = ref.read(gameEngineProvider.notifier);

    if (session == null) return const Scaffold();

    // Find host name
    String hostName = 'UNKNOWN';
    for (final player in session.players) {
      if (session.playerRoles[player.id] == GameRole.host) {
        hostName = player.name;
        break;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Text(
                'FIND THE SECRET WORD',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              
              CountdownTimer(
                duration: session.settings.questionTime,
                onTimerComplete: () {
                  engine.handleTimeUp();
                  // For now navigate to result if time is up, or home
                  context.go('/');
                },
              ),
              
              const Spacer(),
              
              Text(
                'HOST:',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hostName.toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.hostAccent,
                ),
              ),
              
              const Spacer(flex: 2),
              
              PrimaryButton(
                text: 'ANSWER FOUND',
                onPressed: () {
                  _showConfirmationDialog(context, ref);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Confirm'),
        content: const Text('Did someone correctly guess the secret word?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('NO'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              ref.read(gameEngineProvider.notifier).markAnswerFound();
              context.push('/guesser');
            },
            child: const Text('YES', style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }
}
