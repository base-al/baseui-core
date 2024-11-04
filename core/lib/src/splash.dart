import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'modules/auth/controllers/auth_controller.dart';
import 'modules/home/routes.dart';

class SplashController extends GetxController {
  final RxString loadingMessage = 'Initializing...'.obs;
  AuthController get authController => Get.find<AuthController>();
  final String? requestedRoute = Uri.base.path == '/' ? null : Uri.base.path;
  final config = Get.find<AppConfigBase>();
  @override
  void onInit() {
    super.onInit();
    debugPrint('[SplashController] Initializing with route: $requestedRoute');
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      loadingMessage.value = 'Checking authentication...';

      // Wait for auth to be ready
      await authController.initializeAuth();

      // Wait until auth is checked
      while (!authController.isAuthChecked) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Minimum splash duration
      await Future.delayed(const Duration(seconds: 2));

      debugPrint(
          '[SplashController] Auth check complete. Logged in: ${authController.isLoggedIn}');

      // Navigate based on auth state
      final destination = _getDestination();
      debugPrint('[SplashController] Navigating to: $destination');

      await Get.offAllNamed(destination);
    } catch (e) {
      debugPrint('[SplashController] Error: $e');
      await Get.offAllNamed('/auth/login');
    }
  }

  String _getDestination() {
    if (authController.isLoggedIn) {
      return requestedRoute ?? config.homeRoute;
    } else {
      if (requestedRoute != null) {
        authController.redirectAfterLogin = requestedRoute;
      }
      return '/auth/login';
    }
  }
}

class Splash extends GetView<SplashController> {
  Splash({super.key});
  final config = Get.find<AppConfigBase>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              config.primaryColor.withOpacity(0.5),
              config.primaryColor.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                Hero(
                  tag: 'app_logo',
                  child: Container(
                    width: 120,
                    height: 120,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const SvgLogo(), // App logo here
                  ),
                ),

                const SizedBox(height: 48),

                // Loading Indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withOpacity(0.9),
                          ),
                          strokeWidth: 2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Observing the loading message dynamically
                      Obx(() => Text(
                            controller.loadingMessage
                                .value, // Dynamic message from the controller
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SplashMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Only allow direct access to splash if there's a redirect parameter
    if (route == '/' && !Get.parameters.containsKey('redirect')) {
      return const RouteSettings(name: HomeRoutes.index);
    }
    return null;
  }
}

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SplashController>()) {
      Get.put<SplashController>(SplashController());
    }
  }
}
