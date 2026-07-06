class Subject {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final List<Unit> units;

  const Subject({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.units,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      iconName: json['iconName'] as String? ?? 'book',
      units: (json['units'] as List<dynamic>?)
              ?.map((e) => Unit.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class Unit {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final List<Module> modules;
  final RevisionData revision;
  final List<LessonCard> unitSummary;
  final QuizData unitQuiz;
  final List<QuizQuestion> pyqs;

  // Backward-compatibility getter
  QuizData get quiz => unitQuiz;

  const Unit({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.modules,
    required this.revision,
    required this.unitQuiz,
    required this.unitSummary,
    required this.pyqs,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      modules: (json['modules'] as List<dynamic>?)
              ?.map((e) => Module.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      revision: json['revision'] != null
          ? RevisionData.fromJson(json['revision'] as Map<String, dynamic>)
          : const RevisionData(cards: [], recapQuestions: []),
      unitQuiz: QuizData.fromJson(
        json['unitQuiz'] as Map<String, dynamic>? ?? json['quiz'] as Map<String, dynamic>?,
        '${json['id']}_quiz',
        'Unit Comprehensive Test',
      ),
      unitSummary: (json['unitSummary']?['cards'] as List<dynamic>?)
              ?.map((e) => LessonCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pyqs: (json['pyqs'] as List<dynamic>?)
              ?.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class Module {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final List<Lesson> lessons;
  final RevisionData revision;
  final List<LessonCard> moduleSummary;
  final QuizData moduleQuiz;

  // Backward-compatibility getter
  QuizData get quiz => moduleQuiz;

  const Module({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.lessons,
    required this.revision,
    required this.moduleQuiz,
    required this.moduleSummary,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((e) => Lesson.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      revision: json['revision'] != null
          ? RevisionData.fromJson(json['revision'] as Map<String, dynamic>)
          : const RevisionData(cards: [], recapQuestions: []),
      moduleQuiz: QuizData.fromJson(
        json['moduleQuiz'] as Map<String, dynamic>? ?? json['quiz'] as Map<String, dynamic>?,
        '${json['id']}_quiz',
        'Practice Quiz',
      ),
      moduleSummary: (json['moduleSummary']?['cards'] as List<dynamic>?)
              ?.map((e) => LessonCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class LessonCard {
  final String heading;
  final String body;
  final String? tip;
  final int readingTimeMinutes;

  const LessonCard({
    required this.heading,
    required this.body,
    this.tip,
    required this.readingTimeMinutes,
  });

  factory LessonCard.fromJson(Map<String, dynamic> json) {
    return LessonCard(
      heading: json['heading'] as String? ?? '',
      body: json['body'] as String? ?? '',
      tip: json['tip'] as String?,
      readingTimeMinutes: json['readingTimeMinutes'] as int? ?? 5,
    );
  }
}

class Lesson {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final int readingTimeMinutes;
  final List<LessonCard> cards;
  final List<LessonCard> lessonSummary;
  final RevisionData lessonRevision;
  final QuizData lessonQuiz;

  // Backward-compatibility getters
  List<LessonCard> get summary => lessonSummary;
  RevisionData get revision => lessonRevision;
  QuizData get quiz => lessonQuiz;

  const Lesson({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.readingTimeMinutes,
    required this.cards,
    required this.lessonSummary,
    required this.lessonRevision,
    required this.lessonQuiz,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      readingTimeMinutes: json['readingTimeMinutes'] as int? ?? 5,
      cards: (json['cards'] as List<dynamic>?)
              ?.map((e) => LessonCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lessonSummary: (json['lessonSummary']?['cards'] as List<dynamic>?)
              ?.map((e) => LessonCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lessonRevision: json['lessonRevision'] != null
          ? RevisionData.fromJson(json['lessonRevision'] as Map<String, dynamic>)
          : const RevisionData(cards: [], recapQuestions: []),
      lessonQuiz: QuizData.fromJson(
        json['lessonQuiz'] as Map<String, dynamic>?,
        '${json['id']}_quiz',
        'Lesson Quiz',
      ),
    );
  }

  String get content {
    final buffer = StringBuffer();
    for (final card in cards) {
      buffer.writeln('## ${card.heading}');
      buffer.writeln(card.body);
      if (card.tip != null) {
        buffer.writeln('\n> ${card.tip}\n');
      }
      buffer.writeln();
    }
    return buffer.toString().trim();
  }
}

class QuizQuestion {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final int? year;
  final String? sourceTopic;

  const QuizQuestion({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    this.year,
    this.sourceTopic,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String? ?? '',
      questionText: json['questionText'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)?.cast<String>() ?? const [],
      correctOptionIndex: json['correctOptionIndex'] as int? ?? 0,
      explanation: json['explanation'] as String? ?? '',
      year: json['year'] as int?,
      sourceTopic: json['sourceTopic'] as String?,
    );
  }
}

class QuizData {
  final String id;
  final String title;
  final List<QuizQuestion> questions;

  const QuizData({
    required this.id,
    required this.title,
    required this.questions,
  });

  factory QuizData.fromJson(
    Map<String, dynamic>? json,
    String fallbackId,
    String fallbackTitle,
  ) {
    if (json == null) {
      return QuizData(
        id: fallbackId,
        title: fallbackTitle,
        questions: const [],
      );
    }
    return QuizData(
      id: json['id'] as String? ?? fallbackId,
      title: json['title'] as String? ?? fallbackTitle,
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class RevisionCard {
  final String heading;
  final String body;
  final String? tip;
  final int readingTimeMinutes;

  const RevisionCard({
    required this.heading,
    required this.body,
    this.tip,
    required this.readingTimeMinutes,
  });

  factory RevisionCard.fromJson(Map<String, dynamic> json) {
    return RevisionCard(
      heading: json['heading'] as String? ?? 'Key Point',
      body: json['body'] as String? ?? '',
      tip: json['tip'] as String?,
      readingTimeMinutes: json['readingTimeMinutes'] as int? ?? 5,
    );
  }
}

class RevisionData {
  final List<RevisionCard> cards;
  final List<QuizQuestion> recapQuestions;

  const RevisionData({
    required this.cards,
    required this.recapQuestions,
  });

  factory RevisionData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> cardsData =
        json['cards'] ?? json['keypoints'] ?? const [];
    final List<dynamic> recapQs = json['recapQuestions'] ?? const [];

    final List<RevisionCard> cards = cardsData.map((c) {
      if (c is String) {
        return RevisionCard(heading: 'Key Point', body: c, tip: null, readingTimeMinutes: 5);
      }
      return RevisionCard.fromJson(c as Map<String, dynamic>);
    }).toList();

    return RevisionData(
      cards: cards,
      recapQuestions: recapQs
          .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
