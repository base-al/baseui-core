import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final _storage = BaseStorage();
  final config = Get.find<AppConfigBase>();
  late bool _isDarkMode;

  @override
  void onInit() {
    super.onInit();
    final key = config.darkModeKey;
    _isDarkMode = _storage.read(key) ?? false;
    Get.changeThemeMode(_isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  bool get isDarkMode => _isDarkMode;

  void saveThemeMode(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    final key = config.darkModeKey;
    _storage.write(key, isDarkMode);
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
    update();
  }

  void toggleTheme() {
    saveThemeMode(!_isDarkMode);
  }

  Color get backgroundColor => _isDarkMode
      ? const Color.fromARGB(255, 52, 52, 52)
      : config.backgroundColor;

  Color get textColor => _isDarkMode ? config.darkText : config.textColor;
}
