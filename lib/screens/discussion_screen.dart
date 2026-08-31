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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'DISCUSSION ROUND',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.hostAccent,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(flex: 1),
              
              Text(
                'Who knew\ntoo much?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              
              const Spacer(flex: 2),
              
              Center(
                child: CountdownTimer(
                  duration: session.settings.discussionTime,
                  onTimerComplete: () {
                    // Timer expired, optionally auto-proceed to voting
                  },
                ),
              ),
              
              const Spacer(flex: 2),
              
              Text(
                'Discuss and decide.\nThen vote privately.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              
              const Spacer(flex: 3),
              
              PrimaryButton(
                text: 'Start Voting',
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
