import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../core/journey_timeline.dart';
import '../unit/unit_detail_view.dart';

/// Screen listing units within a subject using a timeline-like Unit Journey Map.
class SubjectView extends StatelessWidget {
  final Subject subject;

  const SubjectView({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(subject.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(theme, isDark),
            const SizedBox(height: 32),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: subject.units.length,
              itemBuilder: (context, index) {
                final unit = subject.units[index];
                final isFirst = index == 0;
                final isLast = index == subject.units.length - 1;

                // All units are active and unlocked by default
                const status = JourneyStatus.active;
                const nextStatus = JourneyStatus.active;

                return JourneyTimelineItem(
                  status: status,
                  isFirst: isFirst,
                  isLast: isLast,
                  nextStatus: nextStatus,
                  icon: Icons.account_tree,
                  content: _buildUnitCard(context, unit, theme, isDark),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151D30) : Colors.blue.shade50.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : Colors.blue.shade100,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.map,
            size: 36,
            color: isDark ? Colors.amber : theme.primaryColor,
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Syllabus Journey Map',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  'All journey nodes are unlocked and open for flexible learning.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitCard(
    BuildContext context,
    Unit unit,
    ThemeData theme,
    bool isDark,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.amber.withOpacity(0.5) : theme.primaryColor.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UnitDetailView(unit: unit),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                unit.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                unit.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${unit.modules.length} Modules  •  ${_totalLessonsCount(unit)} Lessons',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'Ready to Start',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _totalLessonsCount(Unit unit) {
    int total = 0;
    for (final m in unit.modules) {
      total += m.lessons.length;
    }
    return total;
  }
}
