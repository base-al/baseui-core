import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    if (!authController.isAuthChecked) {
      debugPrint(
          '[AuthMiddleware] Auth check not completed. Skipping redirect.');
      return null;
    }

    if (!authController.isLoggedIn) {
      authController.redirectAfterLogin = route;
      debugPrint(
          '[AuthMiddleware] User not logged in. Redirecting to /auth/login');
      return const RouteSettings(name: '/auth/login');
    }

    return null;
  }
}
