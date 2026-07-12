import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryBlue = Color.fromARGB(255, 0, 81, 255);
  static const Color backgroundColor = Color.fromARGB(255, 231, 238, 255);
  static const Color lightBlueBackground = Color.fromARGB(255, 231, 238, 255);
  static const Color primaryColor = primaryBlue;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    primaryColor: primaryBlue,
    colorScheme: const ColorScheme.light(
      primary: primaryBlue,
      onPrimary: Colors.white,
      primaryContainer: Color.fromARGB(255, 51, 122, 255),
      secondary: primaryBlue,
      surface: backgroundColor,
      surfaceTint: Colors.white,
      onSurface: Color.fromARGB(255,33,33,33),
    ),
    
    scaffoldBackgroundColor: backgroundColor,
    
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.montserratAlternates(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white
      )
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
    ),
    
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
      ),
    ),

    textTheme: GoogleFonts.montserratAlternatesTextTheme(
      const TextTheme(
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900
        ),
        bodyLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500
        ),
        bodyMedium: TextStyle(
            fontSize: 16,
        ),
      ),
    ),
  );
}
