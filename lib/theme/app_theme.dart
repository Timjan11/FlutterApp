import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryBlue = Color.fromARGB(255, 0, 81, 255);
  static const Color backgroundColorLight = Color.fromARGB(255, 231, 238, 255);
  static const Color backgroundColorDark = Color.fromARGB(255, 18, 18, 18);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color.fromARGB(255, 30, 30, 30);
  static const Color textLight = Color.fromARGB(255, 33, 33, 33);
  static const Color textDark = Color.fromARGB(255, 220, 220, 220);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryBlue,
    colorScheme: const ColorScheme.light(
      primary: primaryBlue,
      onPrimary: Colors.white,
      primaryContainer: Color.fromARGB(255, 51, 122, 255),
      secondary: primaryBlue,
      surface: backgroundColorLight,
      surfaceTint: Colors.white,
      onSurface: textLight,
    ),
    scaffoldBackgroundColor: backgroundColorLight,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.montserratAlternates(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      color: surfaceLight,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    textTheme: GoogleFonts.montserratAlternatesTextTheme(
      const TextTheme(
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textLight,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: textLight,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textLight,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: textLight,
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryBlue,
    colorScheme: const ColorScheme.dark(
      primary: primaryBlue,
      onPrimary: Colors.white,
      primaryContainer: Color.fromARGB(255, 51, 122, 255),
      secondary: primaryBlue,
      surface: backgroundColorDark,
      surfaceTint: Color.fromARGB(255, 50, 50, 50),
      onSurface: textDark,
    ),
    scaffoldBackgroundColor: backgroundColorDark,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.montserratAlternates(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    textTheme: GoogleFonts.montserratAlternatesTextTheme(
      const TextTheme(
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: textDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: textDark,
        ),
      ),
    ),
  );
}