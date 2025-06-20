import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  static ThemeData get theme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
    scaffoldBackgroundColor: Colors.white,
    useMaterial3: true,
    textTheme: _getSystemTextTheme(),
  );

  // Use system fonts with good fallbacks
  static TextTheme _getSystemTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'System',
        fontWeight: FontWeight.normal,
      ),
      displayMedium: TextStyle(
        fontFamily: 'System',
        fontWeight: FontWeight.normal,
      ),
      displaySmall: TextStyle(
        fontFamily: 'System',
        fontWeight: FontWeight.normal,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'System',
        fontWeight: FontWeight.normal,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'System',
        fontWeight: FontWeight.normal,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'System',
        fontWeight: FontWeight.normal,
      ),
      titleLarge: TextStyle(fontFamily: 'System', fontWeight: FontWeight.w500),
      titleMedium: TextStyle(fontFamily: 'System', fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontFamily: 'System', fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontFamily: 'System', fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(
        fontFamily: 'System',
        fontWeight: FontWeight.normal,
      ),
      bodySmall: TextStyle(fontFamily: 'System', fontWeight: FontWeight.normal),
      labelLarge: TextStyle(fontFamily: 'System', fontWeight: FontWeight.w500),
      labelMedium: TextStyle(fontFamily: 'System', fontWeight: FontWeight.w500),
      labelSmall: TextStyle(fontFamily: 'System', fontWeight: FontWeight.w500),
    );
  }
}
