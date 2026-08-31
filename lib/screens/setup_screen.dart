import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_player_row.dart';
import '../widgets/app_setting_row.dart';
import '../theme/colors.dart';
import '../models/player.dart';
import '../services/game_engine.dart';
import '../services/word_service.dart';
import '../services/settings_provider.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  int _playerCount = 6;
  final List<TextEditingController> _nameControllers = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameControllers.clear();
    for (int i = 0; i < _playerCount; i++) {
      _nameControllers.add(TextEditingController(text: 'Player ${i + 1}'));
    }
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wordPacksAsync = ref.watch(wordPacksProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Game'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  Text(
                    'PLAYERS',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 1.5,
                        ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '$_playerCount / 12',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.accent,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  // Player List
                  ...List.generate(_playerCount, (index) {
                    return AppPlayerRow(
                      name: _nameControllers[index].text,
                      controller: _nameControllers[index],
                      onChanged: (val) {
                        // Triggers rebuild for initial update
                        setState(() {});
                      },
                      onRemove: () {
                        if (_playerCount > 4) {
                          setState(() {
                            _playerCount--;
                            _nameControllers.removeAt(index).dispose();
                          });
                        }
                      },
                    );
                  }),
                  
                  const SizedBox(height: 8),
                  
                  // Add Player Button
                  OutlinedButton(
                    onPressed: _playerCount < 12 ? () {
                      setState(() {
                        _playerCount++;
                        _nameControllers.add(TextEditingController(text: 'Player $_playerCount'));
                      });
                    } : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accent,
                      side: BorderSide(color: AppColors.accent.withAlpha(76), width: 1.5), // Subtle purple outline
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      '+ Add Player',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.accent,
                          ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Settings Rows
                  wordPacksAsync.when(
                    data: (packs) {
                      final packName = packs.isNotEmpty ? packs.first.name : 'Default';
                      // Capitalize first letter properly if needed, but assuming data is fine.
                      return AppSettingRow(
                        label: 'Word Pack',
                        value: packName,
                        onTap: () {
                          // Navigation or selection bottom sheet could go here.
                        },
                      );
                    },
                    loading: () => const SizedBox(),
                    error: (err, stack) => const SizedBox(),
                  ),
                  
                  AppSettingRow(
                    label: 'Difficulty',
                    value: 'Normal',
                    onTap: () {},
                  ),
                  
                  AppSettingRow(
                    label: 'Question Time',
                    value: '${settings.questionTime.inSeconds} sec',
                    onTap: () => context.push('/settings'),
                  ),
                  
                  AppSettingRow(
                    label: 'Discussion Time',
                    value: '${settings.discussionTime.inSeconds} sec',
                    onTap: () => context.push('/settings'),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Start Game Button
                  wordPacksAsync.when(
                    data: (packs) {
                      return PrimaryButton(
                        text: 'Start Game',
                        onPressed: packs.isEmpty ? null : () {
                          final players = _nameControllers.asMap().entries.map((e) {
                            final name = e.value.text.trim();
                            return Player(
                              id: e.key.toString(),
                              name: name.isEmpty ? 'Player ${e.key + 1}' : name,
                            );
                          }).toList();
                          
                          ref.read(gameEngineProvider.notifier).startGame(
                            settings.copyWith(playerCount: _playerCount), 
                            players, 
                            packs.first,
                          );
                          
                          context.push('/pass_phone');
                        },
                      );
                    },
                    loading: () => const PrimaryButton(text: 'Loading...', isLoading: true),
                    error: (err, _) => const PrimaryButton(text: 'Error'),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
