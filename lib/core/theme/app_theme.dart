import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData dark({
    Color primary = const Color(0xFFF472B6),
    Color secondary = const Color(0xFFC084FC),
    Color surface = const Color(0xFF1A1020),
    Color background = const Color(0xFF0C0A0E),
  }) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        background: background,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
      ),
    );
  }
}
