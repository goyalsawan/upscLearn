import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../core/journey_timeline.dart';
import '../lesson/lesson_view.dart';
import '../lesson/revision_card_view.dart';
import '../module/module_detail_view.dart';
import '../quiz/quiz_view.dart';

/// Screen displaying the Unit details via a connected Module Journey Map timeline.
class UnitDetailView extends StatefulWidget {
  final Unit unit;

  const UnitDetailView({
    super.key,
    required this.unit,
  });

  @override
  State<UnitDetailView> createState() => _UnitDetailViewState();
}

class _UnitDetailViewState extends State<UnitDetailView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // All modules are unlocked by default
    const status = JourneyStatus.active;

    // Extract summary Module 0 (lives outside the Learn timeline)
    final summaryModules = widget.unit.modules
        .where((m) => m.id.endsWith('m0') || m.id.endsWith('_m0'))
        .toList();
    final summaryModule = summaryModules.isNotEmpty ? summaryModules.first : null;
    final hasUnitSummary = widget.unit.unitSummary.isNotEmpty;

    // Remaining modules go into the Learn section timeline
    final timelineModules = widget.unit.modules
        .where((m) => !m.id.endsWith('m0') && !m.id.endsWith('_m0'))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.unit.name.split(':').last.trim()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── SUMMARY SECTION ─────────────────────────────────────────
            if (hasUnitSummary) ...[
              _buildSectionHeader(
                label: 'Summary',
                icon: Icons.map_outlined,
                color: Colors.teal,
                theme: theme,
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _buildSummaryHero(context, widget.unit, theme, isDark),
              const SizedBox(height: 28),
            ] else if (summaryModule != null) ...[
              _buildSectionHeader(
                label: 'Summary',
                icon: Icons.map_outlined,
                color: Colors.teal,
                theme: theme,
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _buildSummaryModuleHero(context, summaryModule, theme, isDark),
              const SizedBox(height: 28),
            ],

            // ── REVISION SECTION ─────────────────────────────────────────
            _buildSectionHeader(
              label: 'Revision',
              icon: Icons.auto_stories_outlined,
              color: const Color(0xFFB45309),
              theme: theme,
              isDark: isDark,
            ),
            const SizedBox(height: 12),

            // Pre-Unit Revision card (no timeline node — section header provides context)
            _buildRevisionSection(theme, isDark),
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

            // Modules timeline
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: timelineModules.length,
              itemBuilder: (context, index) {
                final module = timelineModules[index];

                return JourneyTimelineItem(
                  status: status,
                  isFirst: index == 0,
                  isLast: false,
                  nextStatus: JourneyStatus.active,
                  // Show sequence number in circle instead of folder icon
                  nodeLabel: '${index + 1}',
                  content: _buildModuleCard(context, module, theme, isDark),
                );
              },
            ),

            // Final Unit Quiz Checkpoint is the last node in Learn
            JourneyTimelineItem(
              status: JourneyStatus.active,
              isFirst: timelineModules.isEmpty,
              isLast: true,
              icon: Icons.workspace_premium,
              content: _buildUnitQuizCard(theme, isDark),
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
    final revision = widget.unit.revision;
    final hasCards = revision.cards.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF854D0E).withOpacity(0.15),
                  const Color(0xFF92400E).withOpacity(0.10),
                ]
              : [
                  const Color(0xFFFEF3C7),
                  const Color(0xFFFDE68A),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? const Color(0xFFB45309).withOpacity(0.30)
              : const Color(0xFFF59E0B).withOpacity(0.55),
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
                      ? const Color(0xFFB45309).withOpacity(0.25)
                      : const Color(0xFFB45309).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_stories_outlined,
                  color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Unit Revision Checkpoint',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: isDark ? Colors.white : const Color(0xFF78350F),
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
                            ? const Color(0xFFFCD34D)
                            : const Color(0xFFB45309),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Review the key unit-level concepts and take the prerequisite check before diving into the modules.',
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
                      quiz: widget.unit.quiz,
                      contextLabel: widget.unit.name,
                    ),
                  ),
                );
              },
              icon: Icon(
                hasCards ? Icons.layers_rounded : Icons.quiz_rounded,
                size: 18,
              ),
              label: Text(
                hasCards ? 'Start Revision Checkpoint' : 'Start Prerequisite Check',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB45309),
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

  Widget _buildModuleCard(
    BuildContext context,
    Module module,
    ThemeData theme,
    bool isDark,
  ) {
    int total = module.lessons.length;
    final isSummaryModule = module.id.endsWith('m0') || module.id.endsWith('_m0');

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSummaryModule
              ? Colors.teal
              : (isDark ? Colors.amber.withOpacity(0.5) : theme.primaryColor.withOpacity(0.5)),
          width: isSummaryModule ? 2 : 1.5,
        ),
      ),
      child: InkWell(
        onTap: () {
          if (isSummaryModule && module.lessons.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LessonView(lesson: module.lessons.first),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ModuleDetailView(module: module),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (module.imageUrl != null && module.imageUrl!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      module.imageUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                        width: 48,
                        height: 48,
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
                    if (isSummaryModule)
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'UNIT SUMMARY',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    Text(
                      // Strip the 'Module N:' prefix — number is shown in the timeline node
                      module.name.replaceFirst(RegExp(r'^Module\s*\d+:\s*'), ''),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      module.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$total lessons  •  Unlocked',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.chevron_right,
                  color: isDark ? Colors.amber : theme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnitQuizCard(ThemeData theme, bool isDark) {
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
                        'Unit Comprehensive Quiz',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Test your overall understanding of this unit.',
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
                    builder: (context) => QuizView(quiz: widget.unit.quiz),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Start Unit Quiz',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryModuleHero(
    BuildContext context,
    Module module,
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
                  const Color(0xFF0D9488).withOpacity(0.10),
                ]
              : [
                  const Color(0xFFE6F4F1),
                  const Color(0xFFD8F3EC),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? const Color(0xFF0F766E).withOpacity(0.35)
              : const Color(0xFF0D9488).withOpacity(0.50),
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
              if (module.imageUrl != null && module.imageUrl!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      module.imageUrl!,
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
                        'UNIT SUMMARY MAP',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      module.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      module.description,
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
              if (module.lessons.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonView(lesson: module.lessons.first),
                  ),
                );
              }
            },
            icon: const Icon(Icons.play_circle_fill_rounded, size: 20),
            label: const Text(
              'Read Unit Summary Cards',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade800,
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

  Widget _buildSummaryHero(
    BuildContext context,
    Unit unit,
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
                  const Color(0xFF0D9488).withOpacity(0.10),
                ]
              : [
                  const Color(0xFFE6F4F1),
                  const Color(0xFFD8F3EC),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? const Color(0xFF0F766E).withOpacity(0.35)
              : const Color(0xFF0D9488).withOpacity(0.50),
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
              if (unit.imageUrl != null && unit.imageUrl!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      unit.imageUrl!,
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
                        'UNIT SUMMARY MAP',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${unit.name.split(':').last.trim()} Summary',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Review the key takeaways and core concepts of this unit in a swipeable card deck.',
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
              final dummyLesson = Lesson(
                id: '${unit.id}_summary',
                name: '${unit.name.split(':').last.trim()} Summary',
                description: unit.description,
                readingTimeMinutes: unit.unitSummary.fold<int>(0, (prev, element) => prev + element.readingTimeMinutes),
                cards: unit.unitSummary,
                lessonSummary: const [],
                lessonRevision: const RevisionData(cards: [], recapQuestions: []),
                lessonQuiz: const QuizData(id: 'dummy_quiz', title: 'Quiz', questions: []),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LessonView(lesson: dummyLesson),
                ),
              );
            },
            icon: const Icon(Icons.play_circle_fill_rounded, size: 20),
            label: const Text(
              'Read Unit Summary Cards',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade800,
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
