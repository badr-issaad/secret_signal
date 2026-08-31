import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/primary_button.dart';
import '../theme/colors.dart';
import '../services/game_engine.dart';
import '../models/role.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  int _revealStep = 0;

  @override
  void initState() {
    super.initState();
    _playRevealSequence();
  }

  void _playRevealSequence() async {
    // Wait for initial load
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _revealStep = 1);
    
    // Countdown
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _revealStep = 2);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _revealStep = 3);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _revealStep = 4);
    
    // Show winner
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _revealStep = 5);
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(gameEngineProvider);
    if (session == null) return const Scaffold();

    final agentId = session.playerRoles.entries.firstWhere((e) => e.value == GameRole.agent).key;
    final agentName = session.players.firstWhere((p) => p.id == agentId).name;

    String? accusedName;
    if (session.accusedId != null) {
      accusedName = session.players.firstWhere((p) => p.id == session.accusedId).name;
    }

    final bool agentWon = session.agentEscaped;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),

              // Step 0: The group accused...
              if (_revealStep >= 0 && accusedName != null) ...[
                Text(
                  'THE GROUP ACCUSED...',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  accusedName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
              
              if (_revealStep >= 0 && accusedName == null) ...[
                Text(
                  'THE GROUP TIED!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.agentAccent,
                  ),
                ),
              ],

              const Spacer(),

              // Step 1, 2, 3: Countdown
              if (_revealStep >= 1 && _revealStep < 4)
                Text(
                  '${4 - _revealStep}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 72,
                    color: AppColors.accent,
                  ),
                ),

              // Step 4: True Identity Reveal
              if (_revealStep >= 4) ...[
                if (accusedName != null) ...[
                  Text(
                    accusedName == agentName ? 'WAS THE AGENT!' : 'WAS INNOCENT!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: accusedName == agentName ? AppColors.agentAccent : AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                if (accusedName != agentName) ...[
                  Text(
                    'The real Agent was',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    agentName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.agentAccent,
                    ),
                  ),
                ],
              ],

              const Spacer(),

              // Step 5: Winner Announcement
              if (_revealStep >= 5) ...[
                Text(
                  agentWon ? 'THE AGENT WINS' : 'SEEKERS WIN',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: agentWon ? AppColors.agentAccent : AppColors.accent,
                    letterSpacing: 2,
                  ),
                ),
                const Spacer(),
                PrimaryButton(
                  text: 'Scoreboard',
                  onPressed: () {
                    context.go('/scoreboard');
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

