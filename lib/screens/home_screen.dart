import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import '../theme/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              
              // Title
              Text(
                'SECRET\nSIGNAL',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.1,
                      letterSpacing: 2,
                    ),
              ),
              const SizedBox(height: 16),
              
              // Tagline
              Text(
                'Someone already knows the answer.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              
              const Spacer(flex: 3),
              
              // Buttons
              PrimaryButton(
                text: 'PLAY',
                onPressed: () {
                  context.push('/setup');
                },
              ),
              const SizedBox(height: 16),
              SecondaryButton(
                text: 'HOW TO PLAY',
                onPressed: () {
                  // TODO: Navigate to How to Play
                },
              ),
              const SizedBox(height: 16),
              SecondaryButton(
                text: 'WORD PACKS',
                onPressed: () {
                  // TODO: Navigate to Word Packs
                },
              ),
              const SizedBox(height: 16),
              SecondaryButton(
                text: 'SETTINGS',
                onPressed: () {
                  // TODO: Navigate to Settings
                },
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
