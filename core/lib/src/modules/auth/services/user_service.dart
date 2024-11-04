import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../classes/base_connect.dart';
import '../models/user.dart';

class UserService extends BaseConnect {
  // GET /users - List Users
  Future<List<User>> getUsers() async {
    try {
      final response = await get('/users');

      if (response.hasError) {
        throw HttpException(
          response.statusText ?? 'Failed to fetch users',
          response.statusCode ?? 500,
        );
      }

      return (response.body as List)
          .map((json) => User.fromJson(json))
          .toList();
    } catch (e) {
      throw HttpException(e.toString(), 500);
    }
  }

  // POST /users - Create a new User
  Future<User> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await post('/users', userData);

      if (response.hasError) {
        throw HttpException(
          response.statusText ?? 'Failed to create user',
          response.statusCode ?? 500,
        );
      }

      return User.fromJson(response.body);
    } catch (e) {
      throw HttpException(e.toString(), 500);
    }
  }

  // PUT /users/{id} - Update a User
  Future<User> updateUser(int id, Map<String, dynamic> userData) async {
    try {
      final response = await put('/users/$id', userData);

      if (response.hasError) {
        throw HttpException(
          response.statusText ?? 'Failed to update user',
          response.statusCode ?? 500,
        );
      }
      debugPrint(response.body.toString());
      return User.fromJson(response.body);
    } catch (e) {
      throw HttpException(e.toString(), 500);
    }
  }

  // GET /users/{id} - Get a User
  Future<User> getUser(String id) async {
    try {
      final response = await get('/users/$id');

      if (response.hasError) {
        throw HttpException(
          response.statusText ?? 'Failed to fetch user',
          response.statusCode ?? 500,
        );
      }

      return User.fromJson(response.body);
    } catch (e) {
      throw HttpException(e.toString(), 500);
    }
  }

  // DELETE /users/{id} - Delete a User
  Future<void> deleteUser(int id) async {
    try {
      final response = await delete('/users/$id');

      if (response.hasError) {
        throw HttpException(
          response.statusText ?? 'Failed to delete user',
          response.statusCode ?? 500,
        );
      }
    } catch (e) {
      throw HttpException(e.toString(), 500);
    }
  }

  // PUT /users/{id}/avatar - Update User's avatar
  Future<User> updateAvatar(int id, XFile image) async {
    try {
      final bytes = await image.readAsBytes();

      final form = FormData({
        'avatar': MultipartFile(
          bytes,
          filename: image.name,
        ),
      });

      final response = await put(
        '/users/$id/avatar',
        form,
      );

      if (response.hasError) {
        final errorMessage =
            response.body != null && response.body['error'] != null
                ? response.body['error']
                : response.statusText ?? 'Failed to update avatar';

        throw HttpException(errorMessage, response.statusCode ?? 500);
      }

      return User.fromJson(response.body);
    } catch (e) {
      if (e is HttpException) {
        rethrow;
      } else {
        throw Exception('Error updating avatar: $e');
      }
    }
  }

  // PUT /users/{id}/password - Update User's password
  Future<void> updatePassword(
    int userId, {
    required String currentPassword,
    required String newPassword,
  }) async {
    final body = {
      'OldPassword': currentPassword,
      'NewPassword': newPassword,
    };

    final response = await put(
      '/users/$userId/password',
      body,
      contentType: 'application/json', // Ensure the content type is set
    );

    if (response.hasError) {
      final errorMessage = response.body['error'] ??
          response.statusText ??
          'Failed to update password';
      throw HttpException(
        errorMessage,
        response.statusCode ?? 500,
      );
    }
  }
}

class HttpException implements Exception {
  final String message;
  final int statusCode;

  const HttpException(this.message, this.statusCode);

  @override
  String toString() => message;
}
