import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/primary_button.dart';
import '../theme/colors.dart';
import '../services/game_engine.dart';
import '../models/game_session.dart';
import '../models/role.dart';

class RoleRevealScreen extends ConsumerStatefulWidget {
  const RoleRevealScreen({super.key});

  @override
  ConsumerState<RoleRevealScreen> createState() => _RoleRevealScreenState();
}

class _RoleRevealScreenState extends ConsumerState<RoleRevealScreen> {
  bool _isRevealed = false;

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isRevealed = true;
    });
    HapticFeedback.mediumImpact();
  }

  void _onPointerUp(PointerEvent event) {
    setState(() {
      _isRevealed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameSession = ref.watch(gameEngineProvider);
    final engine = ref.read(gameEngineProvider.notifier);
    
    if (gameSession == null) return const Scaffold();

    final currentPlayer = engine.getCurrentRevealPlayer();
    if (currentPlayer == null) return const Scaffold();

    final role = gameSession.playerRoles[currentPlayer.id]!;
    final secretWord = gameSession.secretWord;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Text(
                'YOUR ROLE',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              
              // Reveal Area
              Listener(
                onPointerDown: _onPointerDown,
                onPointerUp: _onPointerUp,
                onPointerCancel: _onPointerUp,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 300,
                  decoration: BoxDecoration(
                    color: _isRevealed ? AppColors.surface : AppColors.surface.withAlpha(128),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _isRevealed ? _getRoleColor(role) : AppColors.surface,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: _isRevealed 
                      ? _buildRevealedContent(role, secretWord, context)
                      : Text(
                          'HOLD TO REVEAL',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Only show NEXT button after they have revealed (for simplicity in phase 2, we just always show it, or we could track if they have revealed it once).
              // Let's show it always but maybe disabled? No, let's keep it simple.
              PrimaryButton(
                text: 'NEXT PLAYER',
                onPressed: () {
                  engine.nextRevealPlayer();
                  final currentPhase = ref.read(gameEngineProvider)!.currentPhase;
                  
                  if (currentPhase == GamePhase.questionRound) {
                    // Everyone has seen their role
                    context.go('/question_round'); // Will implement in Phase 3
                  } else {
                    context.pop(); // Go back to pass phone screen
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(GameRole role) {
    switch (role) {
      case GameRole.host:
        return AppColors.hostAccent;
      case GameRole.agent:
        return AppColors.agentAccent;
      case GameRole.seeker:
        return AppColors.seekerAccent;
    }
  }

  Widget _buildRevealedContent(GameRole role, String secretWord, BuildContext context) {
    String description = '';
    bool showsWord = false;

    switch (role) {
      case GameRole.host:
        description = 'Answer questions with YES, NO, or MAYBE.';
        showsWord = true;
        break;
      case GameRole.agent:
        description = 'You already know the answer. Guide the group subtly.';
        showsWord = true;
        break;
      case GameRole.seeker:
        description = 'Ask questions to find the secret word.';
        showsWord = false;
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'YOU ARE THE',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            role.displayName,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: _getRoleColor(role),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 24),
          if (showsWord) ...[
            Text(
              'SECRET WORD',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              secretWord.toUpperCase(),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
          ],
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
