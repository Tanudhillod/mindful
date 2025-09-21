import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryPurple = Color(0xFF6A5ACD);
  static const Color accentTeal = Color(0xFF40E0D0);
  static const Color lightBlue = Color(0xFFE6F0FF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFF666666);
  static const Color errorRed = Color(0xFFFF0000);
  static const Color successGreen = Color(0xFF00FF00);
}

ThemeData get appTheme => ThemeData(
  primaryColor: AppColors.primaryPurple,
  hintColor: AppColors.accentTeal,
  scaffoldBackgroundColor: AppColors.lightBlue,
  cardColor: AppColors.cardBackground,
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textDark),
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
    bodyLarge: TextStyle(fontSize: 16, color: AppColors.textLight),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.textLight),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: AppColors.primaryPurple,
    textTheme: ButtonTextTheme.primary,
  ),
);