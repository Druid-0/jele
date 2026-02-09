import 'package:flutter/material.dart';

import 'color_scheme.dart';
import 'text_theme.dart';

ThemeData buildAppTheme() {
  final colorScheme = buildColorScheme();
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: buildTextTheme(),
    scaffoldBackgroundColor: colorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 0,
      titleTextStyle: buildTextTheme().titleLarge?.copyWith(color: colorScheme.onPrimary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
    ),
  );
}
