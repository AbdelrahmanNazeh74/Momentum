import 'package:flutter/material.dart';

class AppColors {
  // Extracted from the app icon
  static const Color primaryColor = Color(0xFF00C2FF); // Cyan/Light Blue from icon
  static const Color secondaryColor = Color(0xFF5D45F9); // Purple/Indigo from icon
  static const Color accentColor = Color(0xFF57F287); // Green from icon
  
  // Light Theme Colors
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Colors.white;
  
  // Dark Theme Colors
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkSurfaceColor = Color(0xFF1E1E1E);
  
  static const Color errorColor = Color(0xFFCF6679);
}

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      tertiary: AppColors.accentColor,
      surface: AppColors.surfaceColor,
      error: AppColors.errorColor,
      background: AppColors.backgroundColor,
    ),
    scaffoldBackgroundColor: AppColors.backgroundColor,
    cardColor: AppColors.surfaceColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceColor,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondaryColor,
      foregroundColor: Colors.white,
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      tertiary: AppColors.accentColor,
      surface: AppColors.darkSurfaceColor,
      error: AppColors.errorColor,
      background: AppColors.darkBackgroundColor,
    ),
    scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    cardColor: AppColors.darkSurfaceColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurfaceColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondaryColor,
      foregroundColor: Colors.white,
    ),
  );
}
