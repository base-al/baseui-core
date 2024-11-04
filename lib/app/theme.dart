import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'config.dart';

class AppTheme {
  static final _baseTheme = AppThemeBase(AppConfig());

  static ThemeData get lightTheme => _baseTheme.lightTheme;
  static ThemeData get darkTheme => _baseTheme.darkTheme;
}
