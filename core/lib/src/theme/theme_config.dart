// core/lib/src/theme/theme_config.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/app_config_base.dart';

class ThemeConfigBase {
  final AppConfigBase config;

  ThemeConfigBase(this.config);

  // Light Theme Colors
  Color get lightBackground => config.backgroundColor;
  Color get lightSurface => Colors.white;
  Color get lightInput => Colors.white;
  Color get lightText => config.textColor;
  Color get lightTextSecondary => config.textColor.withOpacity(0.6);
  Color get lightDivider => Colors.grey.shade300;
  // Dark Theme Colors
  Color get darkBackground => const Color(0xFF1E1E1E);
  Color get darkSurface => const Color(0xFF1E1E1E);
  Color get darkCard => const Color(0xFF252525);
  Color get darkInput => const Color(0xFF2C2C2C);
  Color get darkText => config.darkText;
  Color get darkTextSecondary => Colors.white.withOpacity(0.60);
  Color get darkDivider => Colors.grey.shade900;

  // Typography
  TextTheme get baseTextTheme => GoogleFonts.robotoCondensedTextTheme(
        const TextTheme(),
      );

  InputDecorationTheme lightInputTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: lightInput,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: _defaultInputBorder(config.primaryColor.withOpacity(0.2)),
      enabledBorder: _defaultInputBorder(config.primaryColor.withOpacity(0.2)),
      focusedBorder: _defaultInputBorder(config.primaryColor),
      errorBorder: _defaultInputBorder(config.errorColor),
      labelStyle: TextStyle(color: lightText),
      hintStyle: TextStyle(color: lightTextSecondary),
    );
  }

  InputDecorationTheme darkInputTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: darkInput,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: _defaultInputBorder(darkText.withOpacity(0.1)),
      enabledBorder: _defaultInputBorder(darkText.withOpacity(0.1)),
      focusedBorder: _defaultInputBorder(config.primaryColor),
      errorBorder: _defaultInputBorder(config.errorColor),
      labelStyle: TextStyle(color: darkText),
      hintStyle: TextStyle(color: darkTextSecondary),
    );
  }

  OutlineInputBorder _defaultInputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color),
    );
  }

  ButtonStyle get elevatedButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: config.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      );

  ButtonStyle get textButtonStyle => TextButton.styleFrom(
        foregroundColor: config.primaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      );
}
