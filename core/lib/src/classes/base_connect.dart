// lib/core/classes/base_connect.dart
import 'package:core/src/config/app_config_base.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../modules/auth/controllers/auth_controller.dart';

class BaseConnect extends GetConnect {
  final config = Get.find<AppConfigBase>();
  @override
  void onInit() {
    httpClient.baseUrl = config.apiUrl;
    httpClient.timeout = config.connectionTimeout;
    httpClient.defaultContentType =
        'application/json'; // Set default content type

    // Add default headers
    httpClient.addRequestModifier<dynamic>((request) {
      // Do not set 'Content-Type' here
      request.headers['Accept'] = 'application/json';
      request.headers['X-Api-Key'] = config.apiKey;
      return request;
    });
    // Add response modifier for error handling
    httpClient.addResponseModifier<dynamic>((request, response) {
      debugPrint('Request URL: ${request.url}');
      debugPrint('Request Headers: ${request.headers}');
      debugPrint('Request method: ${request.method}');
      debugPrint('Response Status: ${response.statusCode}');
      // debugPrint('Response Body: ${response.body}');

      if (response.status.hasError) {
        return _handleErrorResponse(response);
      }

      if (response.statusCode == 401) {
        // Only handle unauthorized access if the user is already logged in
        if (AuthController.to.isLoggedIn) {
          AuthController.to.handleUnauthorized();
        }
      }
      return response;
    });
    super.onInit();
  }

  Response _handleErrorResponse(Response response) {
    if (response.statusCode == null) {
      return Response(
        statusCode: 500,
        statusText: 'Network error occurred. Please check your connection.',
      );
    }

    // Extract error message from response if available
    String errorMessage = 'An error occurred';
    if (response.body != null && response.body is Map) {
      errorMessage =
          response.body['message'] ?? response.body['error'] ?? errorMessage;
    }

    switch (response.statusCode) {
      case 401:
        _handleUnauthorized();
        return Response(
          statusCode: 401,
          statusText: errorMessage,
        );
      case 403:
        return Response(
          statusCode: 403,
          statusText: 'Access denied. Please check your API key.',
        );
      case 404:
        return Response(
          statusCode: 404,
          statusText: 'Resource not found',
        );
      case 429:
        return Response(
          statusCode: 429,
          statusText: 'Too many requests. Please try again later.',
        );
      case 500:
        return Response(
          statusCode: 500,
          statusText: 'Internal server error. Please try again later.',
        );
      default:
        return Response(
          statusCode: response.statusCode,
          statusText: errorMessage,
        );
    }
  }

  void _handleUnauthorized() {
    // Get the auth controller and handle logout
    if (Get.isRegistered<AuthController>()) {
      Get.find<AuthController>().handleUnauthorized();
    }
  }

  @override
  Future<Response<T>> get<T>(
    String url, {
    Map<String, dynamic>? query,
    String? contentType,
    Map<String, String>? headers,
    T Function(dynamic)? decoder,
  }) {
    return super
        .get(
          url,
          query: query,
          contentType: contentType,
          headers: headers,
          decoder: decoder,
        )
        .timeout(
          config.connectionTimeout,
          onTimeout: () => Response(
            statusCode: 408,
            statusText: 'Request timeout',
          ),
        );
  }
}
