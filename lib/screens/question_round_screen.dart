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

    if (session == null) return const Scaffold();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'QUESTION ROUND',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(flex: 1),
              
              Text(
                'Ask smart questions.\nFind the secret word.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.4,
                  fontWeight: FontWeight.normal,
                ),
              ),
              
              const Spacer(flex: 2),
              
              Center(
                child: CountdownTimer(
                  duration: session.settings.questionTime,
                  onTimerComplete: () {
                    engine.handleTimeUp();
                    context.go('/');
                  },
                ),
              ),
              
              const Spacer(flex: 3),
              
              PrimaryButton(
                text: 'Answer Found',
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
        backgroundColor: AppColors.elevatedSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Answer Found?',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
          'Did someone correctly guess the secret word?',
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
              ref.read(gameEngineProvider.notifier).markAnswerFound();
              context.push('/guesser');
            },
            child: const Text('Yes', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

