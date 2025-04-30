import 'package:flutter/material.dart';
import 'package:support_local_artisans/config/themes/AppColorsDark.dart';

import 'AppColorsLight.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColorsLight.primary,
    scaffoldBackgroundColor: AppColorsLight.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColorsLight.background,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColorsLight.textPrimary),
      titleTextStyle:
      TextStyle(color: AppColorsLight.textPrimary, fontSize: 20),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColorsLight.textPrimary),
      bodySmall: TextStyle(color: AppColorsLight.textSecondary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColorsLight.border),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColorsLight.snakebar,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColorsLight.primary,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColorsDark.primary,
    scaffoldBackgroundColor:
    const Color(0xFF121212), // تقدر تعمل ملف AppColors.dark برضو لو عايز
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.grey),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColorsDark.snakebar,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColorsDark.primary,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
