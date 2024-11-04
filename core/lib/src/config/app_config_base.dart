// core/lib/src/config/app_config_base.dart
import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class AppConfigBase {
  AppConfigBase();

  String get apiUrl => 'http://localhost:8090/api';
  String get apiKey => 'DefaultKey';

  // App Information
  String get appName => 'App Name';
  String get appVersion => '1.0.0';
  String get appDescription => 'Welcome!';

  // Asset Paths
  String get appLogo => 'assets/images/logo.svg';
  String get appIcon => 'assets/images/icon.png';
  String get appFavicon => 'assets/images/favicon.png';

  // Colors
  Color get primaryColor => HexColor('#006699');
  Color get backgroundColor => HexColor('#f5f5f5');
  Color get textColor => HexColor('#333333');
  Color get darkText => HexColor('#EEEEEE');
  Color get accentColor => HexColor('#f5f5f5');
  Color get errorColor => HexColor('#FF0000');
  Color get warningColor => HexColor('#FFA500');
  Color get successColor => HexColor('#008000');
  Color get infoColor => HexColor('#0000FF');

  // Routes
  String get homeRoute => '/home';

  // API Endpoints
  String get loginEndpoint => '/auth/login';
  String get registerEndpoint => '/auth/register';
  String get logoutEndpoint => '/auth/logout';
  String get forgotPasswordEndpoint => '/auth/forgot-password';
  String get resetPasswordEndpoint => '/auth/reset-password';

  // Storage Keys
  String get authTokenKey => 'auth_token';
  String get userDataKey => 'user_data';
  String get themeKey => 'app_theme';
  String get darkModeKey => 'dark_mode';

  // Timeouts
  Duration get connectionTimeout => const Duration(seconds: 30);
  Duration get cacheTimeout => const Duration(hours: 24);

  // Content
  List<String> get bulletPoints => const [
        'Default bullet point 1',
        'Default bullet point 2',
        'Default bullet point 3',
      ];
}
