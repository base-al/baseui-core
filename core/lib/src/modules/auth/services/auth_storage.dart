import 'dart:convert';

import '../../../classes/base_storage.dart';
import '../models/auth_data.dart';
import '../models/user.dart';

class AuthStorage extends BaseStorage {
  static const String userKey = 'user';
  static const String authDataKey = 'authData';

  /// Saves user data in storage.
  Future<void> saveUser(User user) async {
    await write(userKey, jsonEncode(user.toJson()));
  }

  /// Retrieves user data from storage.
  Future<User?> getUser() async {
    final userStr = read<String>(userKey);
    if (userStr != null) {
      return User.fromJson(jsonDecode(userStr));
    }
    return null;
  }

  /// Saves authentication data in storage.
  Future<void> saveAuthData(AuthData authData) async {
    await write(authDataKey, jsonEncode(authData.toJson()));
  }

  /// Retrieves authentication data from storage.
  Future<AuthData?> getAuthData() async {
    final authDataStr = read<String>(authDataKey);
    if (authDataStr != null) {
      return AuthData.fromJson(jsonDecode(authDataStr));
    }
    return null;
  }

  /// Removes both user and auth data from storage.
  Future<void> removeUser() async {
    await remove(userKey);
    await remove(authDataKey);
  }

  /// Clears all authentication-related data from storage.
  Future<void> clearAll() async {
    await erase();
  }
}
