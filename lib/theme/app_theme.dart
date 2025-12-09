import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primary = Color(0xFF795548); // Brown 500
  static const Color primaryDark = Color(0xFF4E342E); // Brown 800
  static const Color primaryLight = Color(0xFFA1887F); // Brown 300
  
  static const Color accent = Color(0xFFFFC107); // Amber 500
  static const Color accentDark = Color(0xFFFFA000); // Amber 700
  static const Color accentLight = Color(0xFFFFECB3); // Amber 100

  static const Color background = Color(0xFFFDF3E7); // Cream/Beige
  static const Color surface = Colors.white;
  
  static const Color textPrimary = Color(0xFF3E2723); // Brown 900
  static const Color textSecondary = Color(0xFF5D4037); // Brown 700
  static const Color textLight = Color(0xFF8D6E63); // Brown 400

  // Stat Colors
  static const Color hungerColor = Colors.orange;
  static const Color energyColor = Colors.blue;
  static const Color happinessColor = Colors.pink;
  static const Color hygieneColor = Colors.purple;
  static const Color bladderColor = Colors.yellow;

  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: textSecondary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: textSecondary,
  );

  // Theme Data
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: accent,
        surface: surface,
        background: background,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 4,
        shadowColor: primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      useMaterial3: true,
      fontFamily: 'Nunito', // Assuming we might want a rounded font later, but default is fine for now
    );
  }
}
