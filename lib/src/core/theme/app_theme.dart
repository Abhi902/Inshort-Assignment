// lib/src/config/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // Official-ish Netflix red from brand guidelines. [web:12][web:16]
  static const Color _netflixRed = Color(0xFFE50914);
  static const Color _netflixBlack = Color(0xFF141414);
  static const Color _netflixDarkCard = Color(0xFF1F1F1F);

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _netflixRed,
    primaryColorLight: _netflixRed,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 57, fontWeight: FontWeight.bold, color: Colors.black87),
      displayMedium: TextStyle(
          fontSize: 45, fontWeight: FontWeight.bold, color: Colors.black87),
      displaySmall: TextStyle(
          fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
      headlineLarge: TextStyle(
          fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
      headlineMedium: TextStyle(
          fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
      headlineSmall: TextStyle(
          fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black87),
      titleLarge: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black87),
      titleMedium: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
      titleSmall: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
      bodyLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87),
      bodyMedium: TextStyle(
          fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black87),
      bodySmall: TextStyle(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black54),
      labelLarge: TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
      labelMedium: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
      labelSmall: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black54),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      shadowColor: Colors.black26,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _netflixRed,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 0,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.black87),
    dividerColor: Colors.black12,
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _netflixRed,
    primaryColorLight: _netflixRed,
    scaffoldBackgroundColor: _netflixBlack,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 57, fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: TextStyle(
          fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white),
      displaySmall: TextStyle(
          fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
      headlineLarge: TextStyle(
          fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
      headlineMedium: TextStyle(
          fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
      headlineSmall: TextStyle(
          fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
      titleLarge: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
      titleMedium: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
      titleSmall: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white70),
      bodyLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white70),
      bodyMedium: TextStyle(
          fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white70),
      bodySmall: TextStyle(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white54),
      labelLarge: TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      labelMedium: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70),
      labelSmall: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white70),
    ),
    cardTheme: CardTheme(
      color: _netflixDarkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: Colors.black45,
      clipBehavior: Clip.antiAlias,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _netflixRed,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: _netflixRed, width: 2),
      ),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: _netflixDarkCard,
    ),
    iconTheme: const IconThemeData(color: Colors.white70),
    splashColor: _netflixRed.withOpacity(0.3),
    highlightColor: Colors.white.withOpacity(0.08),
    dividerColor: Colors.white.withOpacity(0.2),
  );
}
