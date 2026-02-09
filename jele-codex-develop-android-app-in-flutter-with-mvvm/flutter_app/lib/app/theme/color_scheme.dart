import 'package:flutter/material.dart';

class AppColors {
  static const blue = Color(0xFF2563EB);
  static const blueDark = Color(0xFF1E40AF);
  static const green = Color(0xFF16A34A);
  static const greenDark = Color(0xFF15803D);
  static const purple = Color(0xFF7C3AED);
  static const gray50 = Color(0xFFF9FAFB);
  static const gray100 = Color(0xFFF3F4F6);
  static const gray200 = Color(0xFFE5E7EB);
  static const gray600 = Color(0xFF4B5563);
  static const gray900 = Color(0xFF111827);
}

ColorScheme buildColorScheme() {
  return ColorScheme.fromSeed(
    seedColor: AppColors.blue,
    primary: AppColors.blue,
    secondary: AppColors.green,
    surface: Colors.white,
    background: AppColors.gray50,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.gray900,
    onBackground: AppColors.gray900,
  );
}
