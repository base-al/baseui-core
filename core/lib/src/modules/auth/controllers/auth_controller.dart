// lib/app/modules/auth/controllers/auth_controller.dart
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/auth_data.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/auth_storage.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();
  Rx<AuthData?> authData = Rx<AuthData?>(null);
  Rx<User?> user = Rx<User?>(null);

  final AuthService authService = AuthService.to;
  final AuthStorage storage = AuthStorage();

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool passwordVisible = false.obs;
  final RxBool rememberMe = true.obs;
  final config = Get.find<AppConfigBase>();

  // Store the intended route to redirect after login
  String? redirectAfterLogin;

  // Computed properties
  bool get isLoggedIn =>
      authData.value != null && !authData.value!.isTokenExpired;
  bool get isAuthChecked => _isAuthChecked.value;

  final _isAuthChecked = false.obs;

  @override
  void onInit() {
    super.onInit();
    ever(user, (_) => _handleAuthStateChanged());
    ever(authData, (_) => _handleAuthStateChanged());
  }

  @override
  void onReady() async {
    super.onReady();
    await initializeAuth();
  }

  Future<void> initializeAuth() async {
    if (_isAuthChecked.value) return;
    try {
      await _loadStoredUser();
    } catch (e) {
      debugPrint('[AuthController] Auth initialization error: $e');
    } finally {
      _isAuthChecked.value = true;
      // No need to call _handleAuthStateChanged() here
    }
  }

  Future<void> _loadStoredUser() async {
    final storedUser = await storage.getUser();
    final storedAuthData = await storage.getAuthData();
    if (storedUser != null &&
        storedAuthData != null &&
        !storedAuthData.isTokenExpired) {
      user.value = storedUser;
      authData.value = storedAuthData;
    } else {
      user.value = null;
      authData.value = null;
    }
  }

  void _handleAuthStateChanged() {
    debugPrint(
        '[AuthController] isAuthChecked: $isAuthChecked, isLoggedIn: $isLoggedIn');

    if (isLoggedIn) {
      debugPrint('[AuthController] User is logged in');
      _updateAuthHeader(authData.value!.accessToken);
    } else {
      debugPrint('[AuthController] User is logged out');
      _removeAuthHeader();
      if (isAuthChecked &&
          Get.currentRoute != '/auth/login' &&
          Get.currentRoute != '/') {
        Get.offAllNamed('/auth/login');
      }
    }
  }

  // Login logic
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      final result = await authService.login(email, password);
      final authDataResult = result['authData'] as AuthData;
      final userResult = result['user'] as User;

      if (rememberMe.value) {
        await storage.saveUser(userResult);
        await storage.saveAuthData(authDataResult);
      }

      authData.value = authDataResult;
      user.value = userResult;

      if (redirectAfterLogin != null) {
        Get.offAllNamed(redirectAfterLogin!);
        redirectAfterLogin = null;
      } else {
        Get.offAllNamed(config.homeRoute);
      }
    } on HttpException catch (e) {
      error.value = e.message;
      Get.snackbar(
        'Login Failed',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: config.errorColor.withOpacity(0.1),
        colorText: config.errorColor,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Login Failed', error.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Loading state management
  void _startLoading() {
    isLoading.value = true;
    error.value = '';
  }

  void _stopLoading() {
    isLoading.value = false;
  }

  // Method to update the Authorization header
  void _updateAuthHeader(String token) {
    authService.httpClient.addRequestModifier<dynamic>((request) async {
      request.headers['Authorization'] = 'Bearer $token';
      return request;
    });
  }

  // Method to remove the Authorization header
  void _removeAuthHeader() {
    authService.httpClient.addRequestModifier<dynamic>((request) async {
      request.headers.remove('Authorization');
      return request;
    });
  }

  Future<void> register(String name, String email, String password) async {
    try {
      _startLoading();
      debugPrint('[AuthController] Starting registration for: $email');

      final response = await authService.register(name, email, password);
      final userData = User.fromJson(response.body);

      if (rememberMe.value) {
        await storage.saveUser(userData);
      }

      user.value = userData;
      Get.offAllNamed(config.homeRoute);

      Get.snackbar(
        'Welcome',
        'Account created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      debugPrint('[AuthController] Registration error: $e');
      String errorMessage =
          e is HttpException ? e.message : 'Registration failed';
      error.value = errorMessage;

      Get.snackbar(
        'Registration Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: config.errorColor.withOpacity(0.1),
        colorText: config.errorColor,
      );
    } finally {
      _stopLoading();
    }
  }

  Future<void> logout() async {
    try {
      _startLoading();
      debugPrint('[AuthController] Processing logout');

      await authService.logout();
      await storage.removeUser();
      user.value = null;
      authData.value = null;

      Get.offAllNamed('/auth/login');
      Get.snackbar(
        'Goodbye',
        'Successfully logged out',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      debugPrint('[AuthController] Logout error: $e');
      // Force logout even if API call fails
      await storage.removeUser();
      user.value = null;
      authData.value = null;
      Get.offAllNamed('/auth/login');
    } finally {
      _stopLoading();
    }
  }

  void handleUnauthorized() async {
    debugPrint('[AuthController] Handling unauthorized access');
    await storage.removeUser();
    user.value = null;
    authData.value = null;
    _removeAuthHeader();
    Get.offAllNamed('/auth/login');
    Get.snackbar(
      'Session Expired',
      'Please log in again to continue',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> forgotPassword(String email) async {
    try {
      _startLoading();
      debugPrint('[AuthController] Processing forgot password for: $email');

      await authService.forgotPassword(email);
      Get.offAllNamed('/auth/reset-password');

      Get.snackbar(
        'Check Your Email',
        'We\'ve sent a password reset link to $email',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      debugPrint('[AuthController] Forgot password error: $e');
      String errorMessage =
          e is HttpException ? e.message : 'Failed to send reset instructions';
      error.value = errorMessage;

      Get.snackbar(
        'Request Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: config.errorColor.withOpacity(0.1),
        colorText: config.errorColor,
      );
    } finally {
      _stopLoading();
    }
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      _startLoading();
      debugPrint('[AuthController] Processing password reset for: $email');

      await authService.resetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      );

      Get.offAllNamed('/auth/login');
      Get.snackbar(
        'Success',
        'Your password has been reset successfully. Please log in with your new password.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      debugPrint('[AuthController] Password reset error: $e');
      String errorMessage =
          e is HttpException ? e.message : 'Failed to reset password';
      error.value = errorMessage;

      Get.snackbar(
        'Reset Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: config.errorColor.withOpacity(0.1),
        colorText: config.errorColor,
      );
    } finally {
      _stopLoading();
    }
  }

  // UI helper methods
  void togglePasswordVisibility() =>
      passwordVisible.value = !passwordVisible.value;
  void toggleRememberMe() => rememberMe.value = !rememberMe.value;
  void clearError() => error.value = '';

  // Form validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}
