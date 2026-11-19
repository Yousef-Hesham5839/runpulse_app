import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryVolt   = Color(0xFFCCFF00);
  static const Color secondaryCyan = Color(0xFF00E5FF);
  static const Color background    = Color(0xFF0D0D11);
  static const Color surface       = Color(0xFF16161E);
  static const Color cardBg        = Color(0xFF1E1E2A); 
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E9F);
  static const Color accentRed     = Color(0xFFFF3366);

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        primaryColor: primaryVolt,
        colorScheme: const ColorScheme.dark(
          primary: primaryVolt,
          secondary: secondaryCyan,
          surface: surface,
          error: accentRed,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: background,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryVolt,
            foregroundColor: Colors.black,
            elevation: 0,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
      );
}