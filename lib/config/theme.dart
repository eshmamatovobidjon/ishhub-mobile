import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      colorSchemeSeed: const Color(0xFF2E7D32),
      useMaterial3: true,
      brightness: Brightness.light,
    );
  }
}
