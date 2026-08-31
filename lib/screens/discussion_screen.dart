import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/primary_button.dart';
import '../widgets/countdown_timer.dart';
import '../theme/colors.dart';
import '../services/game_engine.dart';

class DiscussionScreen extends ConsumerWidget {
  const DiscussionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(gameEngineProvider);
    final engine = ref.read(gameEngineProvider.notifier);

    if (session == null) return const Scaffold();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Text(
                'WHO KNEW TOO MUCH?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.agentAccent,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              
              CountdownTimer(
                duration: session.settings.discussionTime,
                onTimerComplete: () {
                  // Timer expired, optionally auto-proceed to voting
                },
              ),
              
              const Spacer(),
              
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Discuss:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '• Who asked suspiciously useful questions?\n\n'
                      '• Who seemed to know where the conversation was going?\n\n'
                      '• Who helped at exactly the right moment?',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(flex: 2),
              
              PrimaryButton(
                text: 'START VOTING',
                onPressed: () {
                  engine.startVoting();
                  context.push('/pass_phone');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
