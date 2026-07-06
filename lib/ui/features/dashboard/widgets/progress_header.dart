import 'package:flutter/material.dart';

/// Renders the user greeting with avatar and a welcome title.
class ProgressHeader extends StatelessWidget {
  const ProgressHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: theme.primaryColor.withOpacity(0.15),
          child: Text(
            'A',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.amber : theme.primaryColor,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Namaste, Aspirant',
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 2),
              Text(
                'Direct Syllabus Landing Map • Ready to Learn',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
