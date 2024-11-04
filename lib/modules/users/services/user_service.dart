import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_connect/http/src/response/response.dart';

import '../models/user.dart';

class UserService extends BaseConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.addResponseModifier(_logResponse);
  }

  Response _logResponse(Request request, Response response) {
    debugPrint('API Request: ${request.method} ${request.url}');
    debugPrint('Response Status: ${response.statusCode}');
    return response;
  }

  Future<Response<Map<String, dynamic>>> getUsers({
    int page = 1,
    int limit = 10,
    String search = '',
  }) async {
    try {
      final response = await get<Map<String, dynamic>>('/users', query: {
        'page': '$page',
        'limit': '$limit',
        if (search.trim().isNotEmpty) 'search': search.trim(),
      });

      if (response.status.hasError) {
        return _handleListError(page, limit, response);
      }

      return response;
    } catch (e) {
      return _handleListError(page, limit, null, error: e);
    }
  }

  Future<Response> getUser(int id) async {
    try {
      final response = await get('/users/$id');
      return _handleResponse(response, 'fetching user');
    } catch (e) {
      return _handleError(e, 'fetching user');
    }
  }

  Future<Response> createUser(User user) async {
    try {
      final response = await post('/users', user.toJson());
      return _handleResponse(response, 'creating user');
    } catch (e) {
      return _handleError(e, 'creating user');
    }
  }

  Future<Response> updateUser(int id, User user) async {
    try {
      final response = await put('/users/$id', user.toJson());
      return _handleResponse(response, 'updating user');
    } catch (e) {
      return _handleError(e, 'updating user');
    }
  }

  Future<Response> deleteUser(int id) async {
    try {
      final response = await delete('/users/$id');
      return _handleResponse(response, 'deleting user');
    } catch (e) {
      return _handleError(e, 'deleting user');
    }
  }

  Future<Response> updateSort(List<int> sortedIds) async {
    try {
      final response = await put(
        '/users/sort',
        {
          'sortedIds': sortedIds,
        },
      );
      return _handleResponse(response, 'deleting user');
    } catch (e) {
      return _handleError(e, 'sorting user');
    }
  }

  Response _handleResponse(Response response, String operation) {
    if (!response.isOk) {
      throw Exception('Error $operation: ${response.statusText}');
    }
    return response;
  }

  Response _handleError(dynamic error, String operation) {
    debugPrint('Error in $operation: $error');
    return Response(
      statusCode: 500,
      statusText: 'Error $operation: $error',
    );
  }

  Response<Map<String, dynamic>> _handleListError(
    int page,
    int limit,
    Response? response, {
    dynamic error,
  }) {
    debugPrint('Error: ${error ?? response?.statusText}');
    return Response(
      statusCode: response?.statusCode ?? 500,
      statusText: response?.statusText ?? error.toString(),
      body: {
        'data': [],
        'pagination': {
          'total': 0,
          'page': page,
          'page_size': limit,
          'total_pages': 0,
        },
      },
    );
  }
}
