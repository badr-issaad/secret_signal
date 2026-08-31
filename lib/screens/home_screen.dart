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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 3),
              
              // Title
              Text(
                'SECRET',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      letterSpacing: 8,
                    ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(AppColors.accent),
                  const SizedBox(width: 12),
                  _buildDot(AppColors.accent),
                  const SizedBox(width: 12),
                  _buildDot(AppColors.textDisabled),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'SIGNAL',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      letterSpacing: 8,
                    ),
              ),
              const SizedBox(height: 24),
              
              // Tagline
              Text(
                'Someone already knows\nthe answer.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              
              const Spacer(flex: 4),
              
              // Buttons
              PrimaryButton(
                text: 'Play',
                onPressed: () {
                  context.push('/setup');
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: 'How to Play',
                onPressed: () {
                  // TODO: Navigate to How to Play
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: 'Word Packs',
                onPressed: () {
                  // TODO: Navigate to Word Packs
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: 'Settings',
                onPressed: () {
                  context.push('/settings');
                },
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
