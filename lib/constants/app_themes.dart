import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF4CAF50),
    primaryColorDark: const Color(0xFF388E3C),
    primaryColorLight: const Color(0xFFC8E6C9),
    accentColor: const Color(0xFFFF9800),
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    fontFamily: 'Poppins',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xFF4CAF50),
    primaryColorDark: const Color(0xFF388E3C),
    primaryColorLight: const Color(0xFF2E7D32),
    accentColor: const Color(0xFFFF9800),
    scaffoldBackgroundColor: const Color(0xFF121212),
    brightness: Brightness.dark,
    fontFamily: 'Poppins',
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 1,
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}