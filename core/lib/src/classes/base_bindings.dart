import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/auth/controllers/auth_controller.dart';
import '../modules/auth/services/auth_service.dart';
import 'navigation_controller.dart';
import 'theme_controller.dart';

class BaseBindings extends Bindings {
  @override
  void dependencies() {
    debugPrint('Initializing BaseBindings...');

    // Core services first
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<ThemeController>(ThemeController(), permanent: true);
    Get.put<NavigationController>(NavigationController(), permanent: true);

    // Don't put SplashController here - let it be created by its binding

    debugPrint('BaseBindings completed initialization.');
  }
}
