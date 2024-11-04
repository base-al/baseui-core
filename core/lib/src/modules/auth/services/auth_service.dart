// lib/app/modules/auth/services/auth_service.dart
import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/auth_data.dart';
import '../models/user.dart';

class AuthService extends BaseConnect {
  //shorthand for Get.find<AuthService>()
  static AuthService get to => Get.find<AuthService>();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      debugPrint('[AuthService] Attempting login for email: $email');

      final response = await post(
        config.loginEndpoint,
        {
          'email': email,
          'password': password,
        },
      );

      // debugPrint('[AuthService] Response status: ${response.statusCode}');
      // debugPrint('[AuthService] Response body: ${response.bodyString}');

      if (response.hasError) {
        // Parse the response body manually
        final responseData = response.bodyString != null
            ? jsonDecode(response.bodyString!)
            : null;

        final errorMessage =
            responseData != null && responseData['error'] != null
                ? responseData['error']
                : response.statusText ?? 'Login failed';

        throw HttpException(errorMessage, response.statusCode ?? 500);
      }

      if (response.body == null) {
        throw const HttpException('Empty response from server', 500);
      }

      final data = response.body is String
          ? jsonDecode(response.body)
          : response.body as Map<String, dynamic>;

      // Parse AuthData and User
      final authData = AuthData(
        accessToken: data['accessToken'] as String,
        exp: data['exp'] as int,
      );

      final user = User.fromJson(data);

      debugPrint('[AuthService] Login successful');
      return {
        'authData': authData,
        'user': user,
      };
    } catch (e) {
      debugPrint('[AuthService] Login error: $e');
      rethrow;
    }
  }

  Future<Response> register(String name, String email, String password) async {
    debugPrint('[AuthService] Attempting registration for email: $email');

    try {
      final response = await post(config.registerEndpoint, {
        'name': name,
        'email': email,
        'password': password,
      });

      return _handleResponse(response, 'registering');
    } catch (e) {
      return _handleError(e, 'registering');
    }
  }

  Future<Response> logout() async {
    debugPrint('[AuthService] Attempting logout');

    try {
      final response = await post(config.logoutEndpoint, null);
      return _handleResponse(response, 'logging out');
    } catch (e) {
      return _handleError(e, 'logging out');
    }
  }

  Future<Response> forgotPassword(String email) async {
    debugPrint('[AuthService] Requesting password reset for email: $email');

    try {
      final response = await post(config.forgotPasswordEndpoint, {
        'email': email,
      });

      return _handleResponse(response, 'requesting password reset');
    } catch (e) {
      return _handleError(e, 'requesting password reset');
    }
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      debugPrint('[AuthService] Attempting password reset for: $email');

      final response = await post(config.resetPasswordEndpoint, {
        'email': email,
        'token': code,
        'new_password': newPassword,
      });

      if (response.hasError) {
        throw HttpException(
          response.statusText ?? 'Failed to reset password',
          response.statusCode ?? 500,
        );
      }
    } catch (e) {
      debugPrint('[AuthService] Reset password error: $e');
      rethrow;
    }
  }

  // Helper method to handle responses
  Response _handleResponse(Response response, String operation) {
    debugPrint('[AuthService] Response for $operation: ${response.statusCode}');
    debugPrint('[AuthService] Response body: ${response.body}');

    if (response.status.hasError) {
      debugPrint('[AuthService] Error in $operation: ${response.statusText}');
      throw Exception('Error $operation: ${response.statusText}');
    }

    return response;
  }

  // Helper method to handle errors
  Response _handleError(dynamic error, String operation) {
    debugPrint('[AuthService] Error in $operation: $error');
    return Response(
      statusCode: 500,
      statusText: 'Error $operation: ${error.toString()}',
    );
  }
}

class HttpException implements Exception {
  final String message;
  final int statusCode;

  const HttpException(this.message, this.statusCode);

  @override
  String toString() => message;
}
