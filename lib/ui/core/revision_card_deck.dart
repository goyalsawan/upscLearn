import 'package:flutter/material.dart';

class RevisionCardDeck extends StatefulWidget {
  final List<String> keypoints;
  final Color accentColor;

  const RevisionCardDeck({
    super.key,
    required this.keypoints,
    required this.accentColor,
  });

  @override
  State<RevisionCardDeck> createState() => _RevisionCardDeckState();
}

class _RevisionCardDeckState extends State<RevisionCardDeck> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.keypoints.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final total = widget.keypoints.length;

    return Column(
      children: [
        // Card swiper container
        SizedBox(
          height: 180,
          child: Row(
            children: [
              // Left navigate arrow
              IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: _currentPage > 0
                      ? (isDark ? Colors.white70 : Colors.black54)
                      : (isDark ? Colors.white24 : Colors.black12),
                ),
                onPressed: _currentPage > 0
                    ? () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),

              // Swiper body
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: total,
                  onPageChanged: (idx) {
                    setState(() {
                      _currentPage = idx;
                    });
                  },
                  itemBuilder: (context, index) {
                    final fact = widget.keypoints[index];
                    return Card(
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: widget.accentColor.withOpacity(isDark ? 0.25 : 0.4),
                          width: 1.5,
                        ),
                      ),
                      color: theme.cardTheme.color ?? theme.colorScheme.surface,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                                ? [
                                    theme.cardTheme.color ?? theme.colorScheme.surface,
                                    theme.scaffoldBackgroundColor,
                                  ]
                                : [
                                    theme.cardTheme.color ?? theme.colorScheme.surface,
                                    widget.accentColor.withOpacity(0.03),
                                  ],
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Card badge tracker
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: widget.accentColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'KEY FACT ${index + 1} OF $total',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: widget.accentColor,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.lightbulb_outline_rounded,
                                  size: 16,
                                  color: widget.accentColor.withOpacity(0.6),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Fact body text
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  fact,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    height: 1.6,
                                    fontFamily: 'Georgia',
                                    color: theme.textTheme.bodyLarge?.color ?? (isDark
                                        ? const Color(0xFFE2E8F0)
                                        : const Color(0xFF334155)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Right navigate arrow
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: _currentPage < total - 1
                      ? (isDark ? Colors.white70 : Colors.black54)
                      : (isDark ? Colors.white24 : Colors.black12),
                ),
                onPressed: _currentPage < total - 1
                    ? () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            total,
            (idx) => AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _currentPage == idx ? 16 : 6,
              decoration: BoxDecoration(
                color: _currentPage == idx
                    ? widget.accentColor
                    : Colors.grey.withOpacity(isDark ? 0.4 : 0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
