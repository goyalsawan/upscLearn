import 'package:flutter/material.dart';

/// Enum representing the available eye-comfort themes.
enum AppThemeMode {
  system,   // Follows system theme using Light Comfort (Warm Ivory) or Dark Comfort (Midnight Slate)
  light,    // Warm Ivory (soft cream, dark slate text)
  sepia,    // Warm Sepia (paper sand, dark brown text - low blue-light)
  slate,    // Soft Slate (cool low-contrast grey, dark slate text)
  dark,     // Midnight Slate (dark blue-grey, off-white text to reduce halation)
  forest,   // Soothing Forest (deep dark olive green, pale sage green text)
}

/// Premium design tokens, styling, and ThemeData definitions for upscLearn.
class AppTheme {
  // Brand Color Palette - Warm Ivory (Light Comfort)
  static const Color ivoryBg = Color(0xFFFAF7F2);
  static const Color ivoryCard = Colors.white;
  static const Color ivoryTextPrimary = Color(0xFF1E293B);
  static const Color ivoryTextSecondary = Color(0xFF57687E);
  static const Color ivoryPrimary = Color(0xFF1E3A8A);
  static const Color ivorySecondary = Color(0xFFD97706);
  static const Color ivoryTertiary = Color(0xFF0F766E);
  static const Color ivoryBorder = Color(0xFFE2E8F0);
  static const Color ivoryInputFill = Color(0xFFF1ECE4);

  // Brand Color Palette - Warm Sepia (Paper Book)
  static const Color sepiaBg = Color(0xFFF4ECD8);
  static const Color sepiaCard = Color(0xFFFAF4E8);
  static const Color sepiaTextPrimary = Color(0xFF3E2723);
  static const Color sepiaTextSecondary = Color(0xFF6D4C41);
  static const Color sepiaPrimary = Color(0xFF5C4033);
  static const Color sepiaSecondary = Color(0xFFB45309);
  static const Color sepiaTertiary = Color(0xFF78350F);
  static const Color sepiaBorder = Color(0xFFDFD1B8);
  static const Color sepiaInputFill = Color(0xFFEADFCA);

  // Brand Color Palette - Soft Slate (Cool Comfort)
  static const Color slateBg = Color(0xFFE6ECEF);
  static const Color slateCard = Color(0xFFF1F5F7);
  static const Color slateTextPrimary = Color(0xFF2C3E50);
  static const Color slateTextSecondary = Color(0xFF566573);
  static const Color slatePrimary = Color(0xFF2C3E50);
  static const Color slateSecondary = Color(0xFF16A085);
  static const Color slateTertiary = Color(0xFF7F8C8D);
  static const Color slateBorder = Color(0xFFC4D2DB);
  static const Color slateInputFill = Color(0xFFD5DFE5);

  // Brand Color Palette - Midnight Slate (Dark Comfort)
  static const Color midnightBg = Color(0xFF111622);
  static const Color midnightCard = Color(0xFF1B2336);
  static const Color midnightTextPrimary = Color(0xFFE2E8F0);
  static const Color midnightTextSecondary = Color(0xFF94A3B8);
  static const Color midnightPrimary = Color(0xFFD97706);
  static const Color midnightSecondary = Color(0xFF38BDF8);
  static const Color midnightTertiary = Color(0xFF0D9488);
  static const Color midnightBorder = Color(0xFF24304A);
  static const Color midnightInputFill = Color(0xFF151D30);

  // Brand Color Palette - Soothing Forest (Midnight Sage)
  static const Color forestBg = Color(0xFF0F1613);
  static const Color forestCard = Color(0xFF17221E);
  static const Color forestTextPrimary = Color(0xFFD8ECE2);
  static const Color forestTextSecondary = Color(0xFF8FA89B);
  static const Color forestPrimary = Color(0xFF10B981);
  static const Color forestSecondary = Color(0xFF34D399);
  static const Color forestTertiary = Color(0xFF059669);
  static const Color forestBorder = Color(0xFF22352D);
  static const Color forestInputFill = Color(0xFF1B2923);

  /// Resolves the theme mode to ThemeData based on selected comfort mode and system theme state.
  static ThemeData getTheme(AppThemeMode mode, {bool systemIsDark = false}) {
    switch (mode) {
      case AppThemeMode.system:
        return systemIsDark ? _midnightTheme : _ivoryTheme;
      case AppThemeMode.light:
        return _ivoryTheme;
      case AppThemeMode.sepia:
        return _sepiaTheme;
      case AppThemeMode.slate:
        return _slateTheme;
      case AppThemeMode.dark:
        return _midnightTheme;
      case AppThemeMode.forest:
        return _forestTheme;
    }
  }

  /// Default Light/Dark themes for backward compatibility.
  static ThemeData get lightTheme => _ivoryTheme;
  static ThemeData get darkTheme => _midnightTheme;

  static ThemeData get _ivoryTheme => _buildTheme(
        brightness: Brightness.light,
        primaryColor: ivoryPrimary,
        secondaryColor: ivorySecondary,
        tertiaryColor: ivoryTertiary,
        backgroundColor: ivoryBg,
        cardColor: ivoryCard,
        textPrimaryColor: ivoryTextPrimary,
        textSecondaryColor: ivoryTextSecondary,
        errorColor: Colors.redAccent,
        inputFillColor: ivoryInputFill,
        borderColor: ivoryBorder,
      );

  static ThemeData get _sepiaTheme => _buildTheme(
        brightness: Brightness.light,
        primaryColor: sepiaPrimary,
        secondaryColor: sepiaSecondary,
        tertiaryColor: sepiaTertiary,
        backgroundColor: sepiaBg,
        cardColor: sepiaCard,
        textPrimaryColor: sepiaTextPrimary,
        textSecondaryColor: sepiaTextSecondary,
        errorColor: Colors.redAccent,
        inputFillColor: sepiaInputFill,
        borderColor: sepiaBorder,
      );

  static ThemeData get _slateTheme => _buildTheme(
        brightness: Brightness.light,
        primaryColor: slatePrimary,
        secondaryColor: slateSecondary,
        tertiaryColor: slateTertiary,
        backgroundColor: slateBg,
        cardColor: slateCard,
        textPrimaryColor: slateTextPrimary,
        textSecondaryColor: slateTextSecondary,
        errorColor: Colors.redAccent,
        inputFillColor: slateInputFill,
        borderColor: slateBorder,
      );

  static ThemeData get _midnightTheme => _buildTheme(
        brightness: Brightness.dark,
        primaryColor: midnightPrimary,
        secondaryColor: midnightSecondary,
        tertiaryColor: midnightTertiary,
        backgroundColor: midnightBg,
        cardColor: midnightCard,
        textPrimaryColor: midnightTextPrimary,
        textSecondaryColor: midnightTextSecondary,
        errorColor: Colors.redAccent,
        inputFillColor: midnightInputFill,
        borderColor: midnightBorder,
      );

  static ThemeData get _forestTheme => _buildTheme(
        brightness: Brightness.dark,
        primaryColor: forestPrimary,
        secondaryColor: forestSecondary,
        tertiaryColor: forestTertiary,
        backgroundColor: forestBg,
        cardColor: forestCard,
        textPrimaryColor: forestTextPrimary,
        textSecondaryColor: forestTextSecondary,
        errorColor: Colors.redAccent,
        inputFillColor: forestInputFill,
        borderColor: forestBorder,
      );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primaryColor,
    required Color secondaryColor,
    required Color tertiaryColor,
    required Color backgroundColor,
    required Color cardColor,
    required Color textPrimaryColor,
    required Color textSecondaryColor,
    required Color errorColor,
    required Color inputFillColor,
    required Color borderColor,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: brightness == Brightness.dark
          ? ColorScheme.dark(
              primary: primaryColor,
              secondary: secondaryColor,
              tertiary: tertiaryColor,
              surface: cardColor,
              error: errorColor,
            )
          : ColorScheme.light(
              primary: primaryColor,
              secondary: secondaryColor,
              tertiary: tertiaryColor,
              surface: cardColor,
              error: errorColor,
            ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: textPrimaryColor),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textPrimaryColor, letterSpacing: -1),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textPrimaryColor, letterSpacing: -0.5),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimaryColor),
        bodyLarge: TextStyle(fontSize: 16, color: textPrimaryColor, height: 1.6),
        bodyMedium: TextStyle(fontSize: 14, color: textSecondaryColor, height: 1.5),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: brightness == Brightness.dark ? backgroundColor : Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.w700,
            color: brightness == Brightness.dark ? backgroundColor : Colors.white,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: TextStyle(color: textSecondaryColor),
      ),
    );
  }
}
