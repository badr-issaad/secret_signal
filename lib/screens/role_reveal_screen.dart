import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_card.dart';
import '../widgets/role_icon.dart';
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
  bool _hasRevealed = false;

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isRevealed = true;
      _hasRevealed = true;
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
        child: Column(
          children: [
            Expanded(
              child: Listener(
                onPointerDown: _onPointerDown,
                onPointerUp: _onPointerUp,
                onPointerCancel: _onPointerUp,
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: double.infinity,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _isRevealed 
                      ? _buildRevealedContent(role, secretWord, context)
                      : _buildHiddenContent(context),
                  ),
                ),
              ),
            ),
            if (_hasRevealed && !_isRevealed)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: PrimaryButton(
                  text: 'Next Player',
                  onPressed: () {
                    engine.nextRevealPlayer();
                    final currentPhase = ref.read(gameEngineProvider)!.currentPhase;
                    
                    if (currentPhase == GamePhase.questionRound) {
                      context.go('/question_round');
                    } else {
                      context.pop(); // Go back to pass phone screen
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHiddenContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.touch_app, size: 64, color: AppColors.textSecondary),
        const SizedBox(height: 24),
        Text(
          'Hold to Reveal',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
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

  IconData _getRoleIcon(GameRole role) {
    switch (role) {
      case GameRole.host:
        return Icons.emoji_events; // Crown equivalent
      case GameRole.agent:
        return Icons.person_outline; // Spy/Agent equivalent
      case GameRole.seeker:
        return Icons.search;
    }
  }

  Widget _buildRevealedContent(GameRole role, String secretWord, BuildContext context) {
    String description = '';
    String article = role == GameRole.seeker ? 'a' : 'the';

    switch (role) {
      case GameRole.host:
        description = 'You know the word.\nGuide the discussion.\nKeep it fair and fun.';
        break;
      case GameRole.agent:
        description = 'You know the word.\nAnswer questions carefully.\nDon\'t give it away.';
        break;
      case GameRole.seeker:
        description = 'Ask smart questions.\nListen closely.\nFind the word.';
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RoleIcon(
            icon: _getRoleIcon(role),
            color: _getRoleColor(role),
            size: 80,
          ),
          const SizedBox(height: 48),
          Text(
            'You are $article',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            role.displayName.toUpperCase(),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: _getRoleColor(role),
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 48),
          
          if (role == GameRole.seeker) ...[
            Text(
              'The secret word\nis unknown to you.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ] else ...[
            Text(
              'Your secret word is',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              color: AppColors.elevatedSurface,
              border: Border.all(color: Colors.transparent),
              child: Text(
                secretWord.toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: _getRoleColor(role),
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 48),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textDisabled,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

