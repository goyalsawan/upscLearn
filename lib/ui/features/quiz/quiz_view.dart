import 'package:flutter/material.dart';
import '../../../data/models.dart';

/// Interactive MCQ engine that displays immediate animated option feedback,
/// shows detailed explanations, and presents a final scorecard.
class QuizView extends StatefulWidget {
  final QuizData quiz;

  const QuizView({
    super.key,
    required this.quiz,
  });

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  // Active quiz states
  int _currentQuestionIndex = 0;
  int? _selectedOptionIndex;
  bool _answerSubmitted = false;
  int _score = 0;
  bool _quizFinished = false;

  void _submitAnswer() {
    if (_selectedOptionIndex == null || _answerSubmitted) return;

    final question = widget.quiz.questions[_currentQuestionIndex];
    final isCorrect = _selectedOptionIndex == question.correctOptionIndex;

    setState(() {
      _answerSubmitted = true;
      if (isCorrect) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null;
        _answerSubmitted = false;
      });
    } else {
      setState(() {
        _quizFinished = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 1. Scorecard View
    if (_quizFinished) {
      return _buildScorecard(theme, isDark);
    }

    // Handle empty quiz edge case
    if (widget.quiz.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.quiz.title),
        ),
        body: const Center(
          child: Text('No questions available in this quiz.'),
        ),
      );
    }

    final question = widget.quiz.questions[_currentQuestionIndex];

    // 2. Main Quiz Interface
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress indicator bar
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / widget.quiz.questions.length,
            backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200,
            color: isDark ? Colors.amber : theme.primaryColor,
            minHeight: 4,
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Question Number tag
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'QUESTION ${_currentQuestionIndex + 1} OF ${widget.quiz.questions.length}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.amber : theme.primaryColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Score: $_score',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Question Text
                  Text(
                    question.questionText,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Options List
                  ...List.generate(question.options.length, (index) {
                    return _buildOptionTile(question, index, theme, isDark);
                  }),
                  
                  // Explanation Card after submission
                  if (_answerSubmitted) ...[
                    const SizedBox(height: 20),
                    _buildExplanationCard(question, theme, isDark),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Action Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: _selectedOptionIndex == null
                    ? null
                    : (_answerSubmitted ? _nextQuestion : _submitAnswer),
                child: Text(
                  _answerSubmitted
                      ? (_currentQuestionIndex == widget.quiz.questions.length - 1
                          ? 'Finish Quiz'
                          : 'Next Question')
                      : 'Submit Answer',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    QuizQuestion question,
    int index,
    ThemeData theme,
    bool isDark,
  ) {
    final isSelected = _selectedOptionIndex == index;
    final isCorrectOption = index == question.correctOptionIndex;

    Color tileColor = isDark ? const Color(0xFF151D30) : Colors.white;
    Color borderClr = isDark ? const Color(0xFF1E293B) : Colors.grey.shade300;
    IconData? suffixIcon;

    if (_answerSubmitted) {
      if (isSelected) {
        if (isCorrectOption) {
          tileColor = Colors.green.shade500.withOpacity(isDark ? 0.2 : 0.15);
          borderClr = Colors.green.shade600;
          suffixIcon = Icons.check_circle;
        } else {
          tileColor = Colors.red.shade500.withOpacity(isDark ? 0.2 : 0.15);
          borderClr = Colors.red.shade600;
          suffixIcon = Icons.cancel;
        }
      } else if (isCorrectOption) {
        tileColor = Colors.green.shade500.withOpacity(isDark ? 0.15 : 0.1);
        borderClr = Colors.green.shade600.withOpacity(0.5);
      }
    } else {
      if (isSelected) {
        borderClr = isDark ? Colors.amber : theme.primaryColor;
        tileColor = (isDark ? Colors.amber : theme.primaryColor).withOpacity(0.08);
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: tileColor,
        border: Border.all(color: borderClr, width: isSelected ? 2 : 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: _answerSubmitted
            ? null
            : () {
                setState(() {
                  _selectedOptionIndex = index;
                });
              },
        leading: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? Colors.amber : theme.primaryColor)
                : (isDark ? const Color(0xFF0B0F19) : Colors.grey.shade100),
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? (isDark ? Colors.amber : theme.primaryColor)
                  : Colors.grey.shade400,
            ),
          ),
          child: Center(
            child: Text(
              String.fromCharCode(65 + index), // A, B, C, D
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? (isDark ? Colors.black : Colors.white)
                    : (isDark ? Colors.white70 : Colors.black87),
              ),
            ),
          ),
        ),
        title: Text(
          question.options[index],
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: suffixIcon != null
            ? Icon(
                suffixIcon,
                color: suffixIcon == Icons.check_circle ? Colors.green : Colors.red,
              )
            : null,
      ),
    );
  }

  Widget _buildExplanationCard(QuizQuestion question, ThemeData theme, bool isDark) {
    final isCorrect = _selectedOptionIndex == question.correctOptionIndex;

    return Card(
      color: isDark ? const Color(0xFF0B0F19) : Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isCorrect ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.info_outline,
                  color: isCorrect ? Colors.green : Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isCorrect ? 'Correct Answer!' : 'Incorrect Answer',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? Colors.green : Colors.orange.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Explanation:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isDark ? Colors.amber : theme.primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              question.explanation,
              style: const TextStyle(fontSize: 13, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScorecard(ThemeData theme, bool isDark) {
    final percentage = (_score / widget.quiz.questions.length) * 100;
    final isPassed = percentage >= 50.0;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Star achievement display
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    color: (isPassed ? Colors.green : Colors.orange).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPassed ? Icons.workspace_premium : Icons.stars,
                    size: 70,
                    color: isPassed ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Quiz Finished!',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.quiz.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 40),
                
                // Score card layout
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text('YOUR SCORE', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            const SizedBox(height: 6),
                            Text(
                              '$_score / ${widget.quiz.questions.length}',
                              style: theme.textTheme.titleLarge?.copyWith(fontSize: 26),
                            ),
                          ],
                        ),
                        Container(width: 1, height: 40, color: Colors.grey.shade300),
                        Column(
                          children: [
                            const Text('ACCURACY', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            const SizedBox(height: 6),
                            Text(
                              '${percentage.toStringAsFixed(0)}%',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: 26,
                                color: isPassed ? Colors.green : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Return to Core Syllabus'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
