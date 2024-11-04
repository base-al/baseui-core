// core/lib/src/theme/app_theme_base.dart
import 'package:flutter/material.dart';

import '../config/app_config_base.dart';
import 'theme_config.dart';

class AppThemeBase {
  final AppConfigBase config;
  late final ThemeConfigBase _themeConfig;

  AppThemeBase(this.config) {
    _themeConfig = ThemeConfigBase(config);
  }

  ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: config.primaryColor,
        secondary: config.accentColor,
        error: config.errorColor,
        surface: _themeConfig.lightSurface,
      ),
      primaryColor: config.primaryColor,
      scaffoldBackgroundColor: _themeConfig.lightBackground,
      canvasColor: Colors.transparent,
      dividerColor: _themeConfig.lightDivider,
      textTheme: _themeConfig.baseTextTheme.copyWith(
        displayLarge: TextStyle(
          color: _themeConfig.lightText,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: _themeConfig.lightText,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: _themeConfig.lightText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: _themeConfig.lightText,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: _themeConfig.lightText,
          fontSize: 14,
        ),
      ),
      inputDecorationTheme: _themeConfig.lightInputTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _themeConfig.elevatedButtonStyle,
      ),
      textButtonTheme: TextButtonThemeData(
        style: _themeConfig.textButtonStyle,
      ),
      cardTheme: CardTheme(
        color: _themeConfig.lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: _themeConfig.lightDivider,
        space: 1,
        thickness: 1,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: _themeConfig.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'RobotoCondensed',
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(Colors.grey[850]),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 8),
          ),
          elevation: WidgetStateProperty.all(8),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),

        // Optional: Style for when using DropdownButtonFormField
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          isDense: false,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
        ),
      ),
      // Input Dec
      snackBarTheme: SnackBarThemeData(
        backgroundColor: config.primaryColor,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: config.primaryColor,
        secondary: config.accentColor,
        error: config.errorColor,
        surface: _themeConfig.darkSurface,
        onSurface: _themeConfig.darkText,
      ),
      primaryColor: config.primaryColor,
      scaffoldBackgroundColor: _themeConfig.darkBackground,
      canvasColor: Colors.transparent,
      dividerColor: _themeConfig.darkDivider,
      textTheme: _themeConfig.baseTextTheme.copyWith(
        displayLarge: TextStyle(
          color: _themeConfig.darkText,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: _themeConfig.darkText,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: _themeConfig.darkText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: _themeConfig.darkText,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: _themeConfig.darkText,
          fontSize: 14,
        ),
      ),
      inputDecorationTheme: _themeConfig.darkInputTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _themeConfig.elevatedButtonStyle,
      ),
      textButtonTheme: TextButtonThemeData(
        style: _themeConfig.textButtonStyle,
      ),
      cardTheme: CardTheme(
        color: _themeConfig.darkCard,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: _themeConfig.darkDivider,
        space: 1,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _themeConfig.darkCard,
        contentTextStyle: TextStyle(color: _themeConfig.darkText),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: _themeConfig.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      iconTheme: IconThemeData(
        color: _themeConfig.darkText,
      ),
      appBarTheme: AppBarTheme(
        color: _themeConfig.darkBackground,
        scrolledUnderElevation: 0,
        elevation: 0,
        iconTheme: IconThemeData(
          color: _themeConfig.darkText,
        ),
      ),
    );
  }
}
