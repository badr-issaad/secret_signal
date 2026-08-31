import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'app_card.dart';

class AppPlayerRow extends StatelessWidget {
  final String name;
  final VoidCallback onRemove;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  
  const AppPlayerRow({
    super.key,
    required this.name,
    required this.onRemove,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    String initial = name.isNotEmpty ? name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?' : '?';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.elevatedSurface,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              alignment: Alignment.center,
              child: Text(
                initial,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: controller != null 
                  ? TextField(
                      controller: controller,
                      onChanged: onChanged,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  : Text(
                      name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
              onPressed: onRemove,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
