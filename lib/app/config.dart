import 'package:core/core.dart';
import 'package:flutter/material.dart';

class AppConfig extends AppConfigBase {
// Singleton implementation
  static final AppConfig _instance = AppConfig._();
  static bool _initialized = false;

  // Factory constructor
  factory AppConfig() {
    if (!_initialized) {
      _initialized = true;
    }
    return _instance;
  }

  // Private constructor
  AppConfig._();
  //Override any of the default values here

  @override
  String get apiUrl => 'http://localhost:8090/api';

  @override
  String get apiKey => 'AlBAFOne';

  @override
  String get appName => 'Base';

  @override
  String get appDescription => 'Welcome to BaseUI!';

  @override
  Color get primaryColor => HexColor('#BA5EA1');

  @override
  List<String> get bulletPoints => const [
        'Change me at app/config.dart',
        'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
      ];

  // Only override what you want to customize
  // Everything else will use the default values from AppConfigBase
}
