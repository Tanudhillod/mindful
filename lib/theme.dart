import 'package:flutter/material.dart';

class AppColors {
  // Calming pastel colors inspired by nature
  static const Color primaryGreen = Color(0xFF81C784);      // Soft sage green
  static const Color primaryBlue = Color(0xFF81B8D8);       // Sky blue
  static const Color primaryPurple = Color(0xFF9C27B0);     // Primary purple
  static const Color accentPeach = Color(0xFFFFCC80);       // Warm peach
  static const Color accentLavender = Color(0xFFB39DDB);    // Gentle lavender
  static const Color accentTeal = Color(0xFF00ACC1);        // Accent teal
  static const Color lightMint = Color(0xFFE8F5E8);         // Very light mint
  static const Color lightBlue = Color(0xFFE3F2FD);         // Light blue
  static const Color softCream = Color(0xFFFFF8E1);         // Warm cream
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF2C3E50);          // Softer dark gray
  static const Color textMedium = Color(0xFF5D6D7E);        // Medium gray
  static const Color textLight = Color(0xFF85929E);         // Light gray
  static const Color errorSoft = Color(0xFFE74C3C);         // Softer red
  static const Color errorRed = Color(0xFFE74C3C);          // Error red
  static const Color successSoft = Color(0xFF27AE60);       // Softer green
  static const Color successGreen = Color(0xFF27AE60);      // Success green
  static const Color warningAmber = Color(0xFFF39C12);      // Warm amber
  
  // Mood colors
  static const Color moodExcellent = Color(0xFF2ECC71);     // Vibrant green
  static const Color moodGood = Color(0xFF3498DB);          // Blue
  static const Color moodOkay = Color(0xFFF39C12);          // Orange
  static const Color moodPoor = Color(0xFFE67E22);          // Dark orange
  static const Color moodTerrible = Color(0xFFE74C3C);      // Red
}

ThemeData get appTheme => ThemeData(
  primaryColor: AppColors.primaryGreen,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryGreen,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: AppColors.lightMint,
  cardColor: AppColors.cardBackground,
  
  textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32, 
        fontWeight: FontWeight.w600, 
        color: AppColors.textDark,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontSize: 24, 
        fontWeight: FontWeight.w600, 
        color: AppColors.textDark,
        letterSpacing: -0.25,
      ),
      headlineSmall: TextStyle(
        fontSize: 20, 
        fontWeight: FontWeight.w500, 
        color: AppColors.textDark,
      ),
      titleLarge: TextStyle(
        fontSize: 18, 
        fontWeight: FontWeight.w500, 
        color: AppColors.textDark,
      ),
      bodyLarge: TextStyle(
        fontSize: 16, 
        fontWeight: FontWeight.w400, 
        color: AppColors.textMedium,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14, 
        fontWeight: FontWeight.w400, 
        color: AppColors.textLight,
        height: 1.4,
      ),
      bodySmall: TextStyle(
        fontSize: 12, 
        fontWeight: FontWeight.w400, 
        color: AppColors.textLight,
      ),
    ),
  
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: Colors.white,
      elevation: 2,
      shadowColor: AppColors.primaryGreen.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  
  cardTheme: CardThemeData(
    elevation: 2,
    shadowColor: Colors.black.withOpacity(0.1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    margin: const EdgeInsets.symmetric(vertical: 4),
  ),
  
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: const IconThemeData(color: AppColors.textDark),
    titleTextStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textDark,
    ),
  ),
  
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.primaryGreen.withOpacity(0.3)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.primaryGreen.withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
);