import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/primary_button.dart';
import '../theme/colors.dart';
import '../services/game_engine.dart';

class WordRevealScreen extends ConsumerWidget {
  const WordRevealScreen({super.key});

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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Text(
                'THE SECRET WORD WAS',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                session.secretWord.toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.textPrimary,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              Text(
                'But someone already knew it.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.agentAccent,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Spacer(flex: 2),
              PrimaryButton(
                text: 'Start Discussion',
                onPressed: () {
                  engine.startDiscussion();
                  context.push('/discussion');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

