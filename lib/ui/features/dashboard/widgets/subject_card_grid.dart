import 'package:flutter/material.dart';
import '../../../../data/models.dart';
import '../../subject/subject_view.dart';

/// Renders a list of UPSC subject cards showing locked/unlocked states.
class SubjectCardGrid extends StatelessWidget {
  final List<Subject> subjects;

  const SubjectCardGrid({
    super.key,
    required this.subjects,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: subjects.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final subject = subjects[index];
        final isPolity = subject.id == 'polity';

        return InkWell(
          onTap: () {
            if (isPolity) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubjectView(subject: subject),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${subject.name} content will be available in version 2.',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: isPolity
                  ? theme.colorScheme.primary.withOpacity(0.06)
                  : theme.cardTheme.color,
              border: Border.all(
                color: isPolity
                    ? theme.colorScheme.primary.withOpacity(0.3)
                    : ((theme.cardTheme.shape as RoundedRectangleBorder?)?.side.color ?? theme.dividerColor),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  _getSubjectIcon(subject.iconName, isPolity, theme, isDark),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: isPolity ? null : Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subject.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isPolity ? Icons.chevron_right : Icons.lock_outline,
                    color: isPolity
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _getSubjectIcon(
    String iconName,
    bool isPolity,
    ThemeData theme,
    bool isDark,
  ) {
    IconData iconData;
    switch (iconName) {
      case 'gavel':
        iconData = Icons.gavel;
        break;
      case 'public':
        iconData = Icons.public;
        break;
      case 'trending_up':
        iconData = Icons.trending_up;
        break;
      case 'history_edu':
        iconData = Icons.history_edu;
        break;
      default:
        iconData = Icons.book;
    }

    final color = isPolity
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withOpacity(0.38);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPolity ? color.withOpacity(0.12) : theme.colorScheme.onSurface.withOpacity(0.06),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: color, size: 24),
    );
  }
}
