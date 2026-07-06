import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'models.dart';

/// Repository that handles parsing syllabus content from JSON file assets.
class ContentRepository {
  /// Loads all subjects from the JSON asset file and maps them to domain models.
  Future<List<Subject>> getAllSubjects() async {
    try {
      final jsonString = await rootBundle.loadString('assets/polity_content.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);
      final List<dynamic> subjectsData = data['subjects'] ?? [];

      return subjectsData
          .map((sMap) => Subject.fromJson(sMap as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // In case of any error, return an empty list
      return const [];
    }
  }
}
