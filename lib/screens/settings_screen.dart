import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/colors.dart';
import '../services/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            _buildSettingSection(
              context: context,
              title: 'Question Timer',
              description: 'How long Seekers have to interrogate the Host.',
              options: [
                _TimerOption(label: '3 min', duration: const Duration(minutes: 3)),
                _TimerOption(label: '5 min', duration: const Duration(minutes: 5)),
                _TimerOption(label: '7 min', duration: const Duration(minutes: 7)),
              ],
              currentValue: settings.questionTime,
              onSelected: (duration) => settingsNotifier.updateQuestionTime(duration),
            ),
            const SizedBox(height: 32),
            _buildSettingSection(
              context: context,
              title: 'Discussion Timer',
              description: 'How long the group has to discuss before voting.',
              options: [
                _TimerOption(label: '1 min', duration: const Duration(minutes: 1)),
                _TimerOption(label: '2 min', duration: const Duration(minutes: 2)),
                _TimerOption(label: '3 min', duration: const Duration(minutes: 3)),
              ],
              currentValue: settings.discussionTime,
              onSelected: (duration) => settingsNotifier.updateDiscussionTime(duration),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSection({
    required BuildContext context,
    required String title,
    required String description,
    required List<_TimerOption> options,
    required Duration currentValue,
    required ValueChanged<Duration> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: options.map((option) {
            final isSelected = option.duration == currentValue;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: InkWell(
                  onTap: () => onSelected(option.duration),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accent : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.accent : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      option.label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _TimerOption {
  final String label;
  final Duration duration;
  const _TimerOption({required this.label, required this.duration});
}
