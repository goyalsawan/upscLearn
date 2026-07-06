import 'package:flutter/material.dart';
import 'data/models.dart';
import 'data/content_repository.dart';
import 'ui/core/theme.dart';
import 'ui/features/dashboard/dashboard_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load syllabus subjects directly from JSON
  final contentRepository = ContentRepository();
  final subjects = await contentRepository.getAllSubjects();

  runApp(MyApp(subjects: subjects));
}

class MyApp extends StatefulWidget {
  final List<Subject> subjects;

  const MyApp({super.key, required this.subjects});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppThemeMode _themeMode = AppThemeMode.system;

  void _setThemeMode(AppThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final systemBrightness = MediaQuery.platformBrightnessOf(context);
    final isSystemDark = systemBrightness == Brightness.dark;

    final currentTheme = AppTheme.getTheme(
      _themeMode,
      systemIsDark: isSystemDark,
    );

    return MaterialApp(
      title: 'upscLearn',
      theme: currentTheme,
      themeMode: currentTheme.brightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: DashboardView(
        subjects: widget.subjects,
        currentThemeMode: _themeMode,
        onThemeChanged: _setThemeMode,
      ),
    );
  }
}
