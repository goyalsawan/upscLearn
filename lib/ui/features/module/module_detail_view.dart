import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../core/journey_timeline.dart';
import '../lesson/lesson_view.dart';
import '../lesson/revision_card_view.dart';
import '../quiz/quiz_view.dart';

/// Screen listing lessons within a module, structured as a sequential Lesson Journey Map.
class ModuleDetailView extends StatefulWidget {
  final Module module;

  const ModuleDetailView({
    super.key,
    required this.module,
  });

  @override
  State<ModuleDetailView> createState() => _ModuleDetailViewState();
}

class _ModuleDetailViewState extends State<ModuleDetailView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // All checkpoints are active/unlocked by default
    const status = JourneyStatus.active;
    const nextStatus = JourneyStatus.active;

    // Extract summary Lesson 0 (lives outside the Learn timeline)
    final summaryLessons = widget.module.lessons
        .where((l) => l.id.endsWith('l0') || l.id.endsWith('_l0'))
        .toList();
    final summaryLesson = summaryLessons.isNotEmpty ? summaryLessons.first : null;

    // Remaining lessons go into the Learn section timeline
    final timelineLessons = widget.module.lessons
        .where((l) => !l.id.endsWith('l0') && !l.id.endsWith('_l0'))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.module.name.split(':').last.trim()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── SUMMARY SECTION ─────────────────────────────────────────
            if (summaryLesson != null) ...[
              _buildSectionHeader(
                label: 'Summary',
                icon: Icons.map_outlined,
                color: Colors.teal,
                theme: theme,
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _buildSummaryLessonHero(context, summaryLesson, theme, isDark),
              const SizedBox(height: 28),
            ],

            // ── REVISION SECTION ─────────────────────────────────────────
            _buildSectionHeader(
              label: 'Revision',
              icon: Icons.layers_outlined,
              color: const Color(0xFF0F766E),
              theme: theme,
              isDark: isDark,
            ),
            const SizedBox(height: 12),

            // Pre-Module Revision is the only node in this section
            JourneyTimelineItem(
              status: JourneyStatus.completed,
              isFirst: true,
              isLast: true,
              nextStatus: nextStatus,
              icon: Icons.menu_book,
              content: _buildRevisionSection(theme, isDark),
            ),
            const SizedBox(height: 28),

            // ── LEARN SECTION ─────────────────────────────────────────────
            _buildSectionHeader(
              label: 'Learn',
              icon: Icons.school_outlined,
              color: theme.primaryColor,
              theme: theme,
              isDark: isDark,
            ),
            const SizedBox(height: 12),

            // Lessons timeline
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: timelineLessons.length,
              itemBuilder: (context, index) {
                final lesson = timelineLessons[index];

                return JourneyTimelineItem(
                  status: status,
                  isFirst: index == 0,
                  isLast: false,
                  nextStatus: JourneyStatus.active,
                  icon: Icons.bookmark_border,
                  content: _buildLessonTile(context, lesson, theme, isDark),
                );
              },
            ),

            // Final Module Practice Quiz is the last checkpoint in Learn
            JourneyTimelineItem(
              status: JourneyStatus.active,
              isFirst: timelineLessons.isEmpty,
              isLast: true,
              icon: Icons.question_answer,
              content: _buildModuleQuizCard(theme, isDark),
            ),
          ],
        ),
      ),
    );
  }

  /// Renders a styled section header with an icon, label, and a divider line.
  Widget _buildSectionHeader({
    required String label,
    required IconData icon,
    required Color color,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 13,
            color: color,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Divider(
            color: color.withValues(alpha: 0.25),
            thickness: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildRevisionSection(ThemeData theme, bool isDark) {
    final revision = widget.module.revision;
    final hasCards = revision.cards.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF0F766E).withOpacity(0.15),
                  const Color(0xFF065F46).withOpacity(0.10),
                ]
              : [
                  const Color(0xFFCCFBF1),
                  const Color(0xFFD1FAE5),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? const Color(0xFF0F766E).withOpacity(0.30)
              : const Color(0xFF14B8A6).withOpacity(0.45),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0F766E).withOpacity(0.25)
                      : const Color(0xFF0F766E).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.layers_outlined,
                  color: isDark ? const Color(0xFF14B8A6) : const Color(0xFF0F766E),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Module Warmup Checkpoint',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: isDark ? Colors.white : const Color(0xFF134E4A),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      hasCards
                          ? '${revision.cards.length} revision card${revision.cards.length == 1 ? '' : 's'} · prerequisite check'
                          : 'Prerequisite check quiz',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? const Color(0xFF5EEAD4)
                            : const Color(0xFF0F766E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Review the core prerequisite facts and take the warmup check quiz before starting this module.',
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RevisionCardView(
                      revision: revision,
                      quiz: widget.module.quiz,
                      contextLabel: widget.module.name,
                    ),
                  ),
                );
              },
              icon: Icon(
                hasCards ? Icons.layers_rounded : Icons.quiz_rounded,
                size: 18,
              ),
              label: Text(
                hasCards ? 'Start Warmup Checkpoint' : 'Start Prerequisite Check',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F766E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonTile(
    BuildContext context,
    Lesson lesson,
    ThemeData theme,
    bool isDark,
  ) {
    final isSummaryLesson = lesson.id.endsWith('l0') || lesson.id.endsWith('_l0');

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSummaryLesson
              ? Colors.teal
              : (isDark ? Colors.amber.withOpacity(0.5) : theme.primaryColor.withOpacity(0.5)),
          width: isSummaryLesson ? 2 : 1.5,
        ),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonView(lesson: lesson),
            ),
          );
        },
        dense: true,
        leading: lesson.imageUrl != null && lesson.imageUrl!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  lesson.imageUrl!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(
                    width: 40,
                    height: 40,
                    color: theme.colorScheme.primary.withOpacity(0.08),
                    child: Icon(Icons.image_not_supported,
                        color: theme.colorScheme.primary, size: 20),
                  ),
                ),
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSummaryLesson)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'MODULE SUMMARY',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
            Text(
              lesson.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        subtitle: Text(
          '${lesson.readingTimeMinutes} mins read',
          style: const TextStyle(
            fontSize: 11,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
        ),
      ),
    );
  }

  Widget _buildModuleQuizCard(ThemeData theme, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.teal.shade900 : Colors.teal.shade200,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Module MCQ Practice',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Test your knowledge on this module.',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizView(quiz: widget.module.quiz),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Start Practice Quiz',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryLessonHero(
    BuildContext context,
    Lesson lesson,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF0F766E).withOpacity(0.20),
                  const Color(0xFF065F46).withOpacity(0.10),
                ]
              : [
                  const Color(0xFFCCFBF1),
                  const Color(0xFFD1FAE5),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? const Color(0xFF0F766E).withOpacity(0.35)
              : const Color(0xFF14B8A6).withOpacity(0.45),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (lesson.imageUrl != null && lesson.imageUrl!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      lesson.imageUrl!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                        width: 56,
                        height: 56,
                        color: theme.colorScheme.primary.withOpacity(0.08),
                        child: Icon(Icons.image_not_supported,
                            color: theme.colorScheme.primary, size: 24),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'MODULE SUMMARY MAP',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      lesson.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lesson.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LessonView(lesson: lesson),
                ),
              );
            },
            icon: const Icon(Icons.play_circle_fill_rounded, size: 20),
            label: const Text(
              'Read Module Summary Cards',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F766E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
