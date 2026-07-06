import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../data/models.dart';
import '../quiz/quiz_view.dart';

/// Full-screen swipeable revision card deck that concludes with a button to launch the prerequisite check QuizView.
class RevisionCardView extends StatefulWidget {
  final RevisionData revision;
  final QuizData quiz;
  final String contextLabel;

  const RevisionCardView({
    super.key,
    required this.revision,
    required this.quiz,
    required this.contextLabel,
  });

  @override
  State<RevisionCardView> createState() => _RevisionCardViewState();
}

class _RevisionCardViewState extends State<RevisionCardView>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  int _currentPage = 0;
  late final AnimationController _progressAnim;
  late final AnimationController _cardAnim;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _cardAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _cardAnim.forward();
    _updateProgress(0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressAnim.dispose();
    _cardAnim.dispose();
    super.dispose();
  }

  void _updateProgress(int page) {
    final total = widget.revision.cards.length;
    if (total == 0) return;
    _progressAnim.animateTo(
      (page + 1) / total,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOutCubic,
    );
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _updateProgress(page);
    _cardAnim.reset();
    _cardAnim.forward();
  }

  void _launchQuiz(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizView(
          quiz: widget.quiz,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cards = widget.revision.cards;
    final total = cards.length;

    if (total == 0) {
      return Scaffold(
        appBar: AppBar(title: const Text('Warmup Checkpoint')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No revision cards available.'),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _launchQuiz(context),
                icon: const Icon(Icons.quiz_rounded),
                label: const Text('Start Prerequisite Check'),
              ),
            ],
          ),
        ),
      );
    }

    final isLast = _currentPage == total - 1;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B0F19)
          : const Color(0xFFF4F6FB),
      appBar: _buildAppBar(theme, isDark, total),
      body: Column(
        children: [
          // ── Animated Progress Bar ──────────────────────────────────────
          _buildProgressBar(isDark),

          // ── Card PageView ───────────────────────────────────────
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: total,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return _buildCard(context, cards[index], index, theme, isDark);
              },
            ),
          ),

          // ── Bottom Navigation Bar ──────────────────────────────────────
          _buildBottomBar(context, theme, isDark, total, isLast),
        ],
      ),
    );
  }

  AppBar _buildAppBar(ThemeData theme, bool isDark, int total) {
    return AppBar(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF4F6FB),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        children: [
          const Text(
            'Warmup Checkpoint',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            widget.contextLabel,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.white38 : Colors.black38,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  Widget _buildProgressBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: AnimatedBuilder(
        animation: _progressAnim,
        builder: (context, _) {
          return Stack(
            children: [
              Container(
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              FractionallySizedBox(
                widthFactor: _progressAnim.value,
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF0F766E),
                        Color(0xFF14B8A6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    RevisionCard card,
    int index,
    ThemeData theme,
    bool isDark,
  ) {
    final cardColors = _cardColorPair(index, isDark);

    return AnimatedBuilder(
      animation: _cardAnim,
      builder: (context, child) {
        return Opacity(
          opacity: _cardAnim.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - _cardAnim.value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF151D30) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark
                        ? cardColors.$1.withOpacity(0.25)
                        : cardColors.$1.withOpacity(0.18),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cardColors.$1.withOpacity(isDark ? 0.08 : 0.10),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Gradient header
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              cardColors.$1,
                              cardColors.$2,
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Card number badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.22),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                'Fact ${index + 1} of ${widget.revision.cards.length}  •  ${card.readingTimeMinutes} mins read',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              card.heading,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Scrollable body content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MarkdownBody(
                                data: card.body,
                                styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                                  p: TextStyle(
                                    fontSize: 15,
                                    height: 1.70,
                                    color: isDark
                                        ? const Color(0xFFCBD5E1)
                                        : const Color(0xFF334155),
                                    fontFamily: 'Georgia',
                                  ),
                                  strong: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                                  ),
                                  listBullet: TextStyle(
                                    fontSize: 15,
                                    color: cardColors.$1.withOpacity(0.8),
                                  ),
                                  pPadding: const EdgeInsets.only(bottom: 10),
                                  listBulletPadding: const EdgeInsets.only(right: 10),
                                ),
                              ),
                              if (card.tip != null) ...[
                                const SizedBox(height: 20),
                                _buildTipBox(card.tip!, isDark, cardColors.$1),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipBox(String tip, bool isDark, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(isDark ? 0.12 : 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: accentColor.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded, color: accentColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Tip',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  tip,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.55,
                    color: isDark
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, ThemeData theme, bool isDark,
      int total, bool isLast) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF4F6FB),
          border: Border(
            top: BorderSide(
              color: isDark
                  ? const Color(0xFF1E293B)
                  : Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Back arrow
            _NavButton(
              icon: Icons.arrow_back_rounded,
              enabled: _currentPage > 0,
              isDark: isDark,
              onTap: () => _goToPage(_currentPage - 1),
            ),
            const SizedBox(width: 12),

            // Center CTA
            Expanded(
              child: isLast
                  ? GestureDetector(
                      onTap: () => _launchQuiz(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7C3AED).withOpacity(0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.quiz_rounded, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Start Prerequisite Check',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () => _goToPage(_currentPage + 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                          ],
                        ),
                      ),
                    ),
            ),

            const SizedBox(width: 12),
            // Forward arrow
            _NavButton(
              icon: Icons.arrow_forward_rounded,
              enabled: _currentPage < total - 1,
              isDark: isDark,
              onTap: () => _goToPage(_currentPage + 1),
            ),
          ],
        ),
      ),
    );
  }

  (Color, Color) _cardColorPair(int index, bool isDark) {
    final palettes = isDark
        ? [
            (const Color(0xFF0F766E), const Color(0xFF0D9488)), // Teal
            (const Color(0xFF1E3A8A), const Color(0xFF1D4ED8)), // Navy
            (const Color(0xFF065F46), const Color(0xFF059669)), // Emerald
            (const Color(0xFF7C3AED), const Color(0xFF9333EA)), // Purple
            (const Color(0xFFB45309), const Color(0xFFD97706)), // Amber
            (const Color(0xFF0F766E), const Color(0xFF14B8A6)), // Teal Light
          ]
        : [
            (const Color(0xFF0F766E), const Color(0xFF14B8A6)), // Teal
            (const Color(0xFF1E3A8A), const Color(0xFF2563EB)), // Navy
            (const Color(0xFF065F46), const Color(0xFF10B981)), // Emerald
            (const Color(0xFF6D28D9), const Color(0xFF8B5CF6)), // Purple
            (const Color(0xFFB45309), const Color(0xFFF59E0B)), // Amber
            (const Color(0xFF0F766E), const Color(0xFF0D9488)), // Teal Dark
          ];
    return palettes[index % palettes.length];
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final bool isDark;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.28,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
      ),
    );
  }
}
