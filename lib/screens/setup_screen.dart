import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/primary_button.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('SETUP GAME'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Player Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Players',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        color: AppColors.textPrimary,
                        onPressed: _playerCount > 4
                            ? () {
                                setState(() {
                                  _playerCount--;
                                  _nameControllers.removeLast().dispose();
                                });
                              }
                            : null,
                      ),
                      Text(
                        '$_playerCount',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        color: AppColors.textPrimary,
                        onPressed: _playerCount < 10
                            ? () {
                                setState(() {
                                  _playerCount++;
                                  _nameControllers.add(TextEditingController(
                                      text: 'Player $_playerCount'));
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              Text(
                'Player Names',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              
              Expanded(
                child: ListView.builder(
                  itemCount: _playerCount,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: TextField(
                        controller: _nameControllers[index],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              wordPacksAsync.when(
                data: (packs) {
                  if (packs.isEmpty) {
                    return const Center(child: Text('No word packs found'));
                  }
                  return PrimaryButton(
                    text: 'START GAME',
                    onPressed: () {
                      final players = _nameControllers.asMap().entries.map((e) {
                        return Player(
                          id: e.key.toString(),
                          name: e.value.text.trim().isEmpty ? 'Player ${e.key + 1}' : e.value.text.trim(),
                        );
                      }).toList();
                      
                      final settings = ref.read(settingsProvider);
                      
                      ref.read(gameEngineProvider.notifier).startGame(
                        settings.copyWith(playerCount: _playerCount), 
                        players, 
                        packs.first,
                      );
                      
                      context.push('/pass_phone');
                    },
                  );
                },
                loading: () => const PrimaryButton(text: 'LOADING...', isLoading: true),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
