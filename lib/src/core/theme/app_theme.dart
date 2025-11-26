import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 1,
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
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
      titleLarge: TextStyle(
          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
      titleMedium: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
      titleSmall: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
      bodyLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87),
      bodyMedium: TextStyle(
          fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black87),
      bodySmall: TextStyle(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black87),
      labelLarge: TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
      labelMedium: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
      labelSmall: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87),
    ),
    cardColor: Colors.white,
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
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
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      titleLarge: TextStyle(
          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      titleMedium: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white70),
      titleSmall: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70),
      bodyLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white70),
      bodyMedium: TextStyle(
          fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white70),
      bodySmall: TextStyle(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white70),
      labelLarge: TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70),
      labelMedium: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70),
      labelSmall: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white70),
    ),
    cardColor: Colors.grey[900],
  );
}
