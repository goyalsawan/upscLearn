import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../core/theme.dart';
import 'widgets/progress_header.dart';
import 'widgets/subject_card_grid.dart';

class DashboardView extends StatefulWidget {
  final List<Subject> subjects;
  final AppThemeMode currentThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const DashboardView({
    super.key,
    required this.subjects,
    required this.currentThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  void _showThemeSelectionSheet() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final activeMode = widget.currentThemeMode;

            final themesList = [
              const _ThemeOption(
                mode: AppThemeMode.system,
                name: 'System Default',
                description: 'Follows device light/dark mode using eye-comfort tones.',
                bgColor: Color(0xFFE2E8F0),
                accentColor: Color(0xFF1E3A8A),
              ),
              const _ThemeOption(
                mode: AppThemeMode.light,
                name: 'Warm Ivory',
                description: 'Soft warm cream tone. Ideal for daytime studying.',
                bgColor: AppTheme.ivoryBg,
                accentColor: AppTheme.ivoryPrimary,
              ),
              const _ThemeOption(
                mode: AppThemeMode.sepia,
                name: 'Warm Sepia',
                description: 'Classic book-paper tone. Reduces harmful blue light.',
                bgColor: AppTheme.sepiaBg,
                accentColor: AppTheme.sepiaPrimary,
              ),
              const _ThemeOption(
                mode: AppThemeMode.slate,
                name: 'Soft Slate',
                description: 'Low-contrast slate grey. Reduces dry eye fatigue.',
                bgColor: AppTheme.slateBg,
                accentColor: AppTheme.slatePrimary,
              ),
              const _ThemeOption(
                mode: AppThemeMode.dark,
                name: 'Midnight Slate',
                description: 'Subdued midnight dark blue. Eliminates screen glare.',
                bgColor: AppTheme.midnightBg,
                accentColor: AppTheme.midnightPrimary,
              ),
              const _ThemeOption(
                mode: AppThemeMode.forest,
                name: 'Forest Soothing',
                description: 'Deep sage green & forest. Best for low light study.',
                bgColor: AppTheme.forestBg,
                accentColor: AppTheme.forestPrimary,
              ),
            ];

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Eye Comfort Settings',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Choose a comfortable reading palette to minimize eye fatigue during long sessions.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: themesList.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = themesList[index];
                          final isSelected = activeMode == item.mode;

                          return InkWell(
                            onTap: () {
                              widget.onThemeChanged(item.mode);
                              setModalState(() {});
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : (theme.cardTheme.shape as RoundedRectangleBorder?)?.side.color ?? Colors.grey.withOpacity(0.2),
                                  width: isSelected ? 2 : 1,
                                ),
                                color: isSelected
                                    ? theme.colorScheme.primary.withOpacity(0.08)
                                    : Colors.transparent,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: item.bgColor,
                                      border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: item.accentColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontSize: 14.5,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 1),
                                        Text(
                                          item.description,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontSize: 11.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: theme.colorScheme.primary,
                                      size: 22,
                                    )
                                  else
                                    Icon(
                                      Icons.circle_outlined,
                                      color: Colors.grey.shade400,
                                      size: 22,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Theme Settings?'),
        content: const Text(
          'This will reset your eye-comfort theme to system default.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.onThemeChanged(AppThemeMode.system);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme settings reset.')),
              );
            },
            child: const Text(
              'Reset',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('upscLearn'),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Eye Comfort Settings',
            onPressed: _showThemeSelectionSheet,
          ),
          IconButton(
            icon: const Icon(Icons.settings_backup_restore),
            tooltip: 'Reset Settings',
            onPressed: _showResetConfirmation,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ProgressHeader(),
            const SizedBox(height: 32),
            Text(
              'Core Subjects',
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            SubjectCardGrid(subjects: widget.subjects),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption {
  final AppThemeMode mode;
  final String name;
  final String description;
  final Color bgColor;
  final Color accentColor;

  const _ThemeOption({
    required this.mode,
    required this.name,
    required this.description,
    required this.bgColor,
    required this.accentColor,
  });
}
