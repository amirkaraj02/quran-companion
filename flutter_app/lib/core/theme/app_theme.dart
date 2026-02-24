import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF1B6B3A);
  static const primaryLight = Color(0xFF2E8B57);
  static const primaryDark = Color(0xFF0D4A27);
  static const accent = Color(0xFFC9A84C);
  static const gold = Color(0xFFD4AF37);
  static const bgLight = Color(0xFFF8F6F0);
  static const bgSepia = Color(0xFFF4E9D0);
  static const bgDark = Color(0xFF1A1A2E);
  static const bgDarkCard = Color(0xFF16213E);
  static const textDark = Color(0xFF1C1C1C);
  static const textGrey = Color(0xFF6B7280);
  static const textLight = Color(0xFFF1F0EA);
  static const tajweedGhunna = Color(0xFF4CAF50);
  static const tajweedMadd = Color(0xFF2196F3);
  static const tajweedQalqalah = Color(0xFF9C27B0);
  static const tajweedIkhfa = Color(0xFFFF9800);
  static const tajweedIdgham = Color(0xFFF44336);
  static const tajweedIqlab = Color(0xFFE91E63);
}

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.bgLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textGrey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: AppColors.bgDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgDarkCard,
      foregroundColor: AppColors.textLight,
      elevation: 0,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.bgDarkCard,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: Colors.grey.shade600,
      type: BottomNavigationBarType.fixed,
    ),
    cardTheme: CardTheme(
      color: AppColors.bgDarkCard,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}