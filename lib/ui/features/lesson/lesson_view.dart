import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../data/models.dart';
import 'lesson_card_view.dart';

/// Distraction-free, highly readable lesson rendering screen with font size controls.
class LessonView extends StatefulWidget {
  final Lesson lesson;

  const LessonView({
    super.key,
    required this.lesson,
  });

  @override
  State<LessonView> createState() => _LessonViewState();
}

class _LessonViewState extends State<LessonView> {
  double _fontSizeScale = 1.0; // 0.8, 1.0, 1.2, 1.4

  void _increaseFontSize() {
    if (_fontSizeScale < 1.4) {
      setState(() {
        _fontSizeScale += 0.2;
      });
    }
  }

  void _decreaseFontSize() {
    if (_fontSizeScale > 0.8) {
      setState(() {
        _fontSizeScale -= 0.2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Route to swipeable card deck when cards are provided
    if (widget.lesson.cards.isNotEmpty) {
      return LessonCardView(
        lesson: widget.lesson,
      );
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.text_fields),
            tooltip: 'Adjust Text Size',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setModalState) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      height: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Font Size Adjustment',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  _decreaseFontSize();
                                  setModalState(() {});
                                },
                              ),
                              const SizedBox(width: 20),
                              Text(
                                '${(_fontSizeScale * 100).toStringAsFixed(0)}%',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  _increaseFontSize();
                                  setModalState(() {});
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Markdown(
              data: widget.lesson.content,
              padding: const EdgeInsets.all(24),
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                p: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 15 * _fontSizeScale,
                  fontFamily: 'Georgia',
                  height: 1.65,
                ),
                h1: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 26 * _fontSizeScale,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                h2: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 20 * _fontSizeScale,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.amber : theme.primaryColor,
                ),
                h3: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 16 * _fontSizeScale,
                  fontWeight: FontWeight.w700,
                ),
                listBullet: TextStyle(
                  fontSize: 15 * _fontSizeScale,
                  fontFamily: 'Georgia',
                ),
              ),
            ),
          ),
          
          // Bottom finish bar
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Finish Lesson'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
