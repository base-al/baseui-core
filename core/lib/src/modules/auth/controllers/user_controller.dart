import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user.dart';
import '../services/user_service.dart';
import 'auth_controller.dart';

class UserController extends GetxController {
  final AuthController authController = AuthController.to;
  final UserService userService = Get.put(UserService());

  // Observables
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool notificationsEnabled = true.obs;
  final RxList<User> users = <User>[].obs;

  // User data shortcuts
  Rx<User?> get currentUser => authController.user;

  // Image picker
  final ImagePicker _picker = ImagePicker();

  void _startLoading() {
    isLoading.value = true;
    error.value = '';
  }

  void _stopLoading() {
    isLoading.value = false;
  }

  void _handleError(dynamic error) {
    this.error.value = error.toString();

    debugPrint('Error: $error');
    _stopLoading();
    Get.snackbar(
      'Error',
      error.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red,
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );
  }

  // User List Management
  Future<void> fetchUsers() async {
    try {
      _startLoading();
      final fetchedUsers = await userService.getUsers();
      users.value = fetchedUsers;
    } catch (e) {
      _handleError('Failed to fetch users: $e');
    } finally {
      _stopLoading();
    }
  }

  Future<void> createUser(Map<String, dynamic> userData) async {
    try {
      _startLoading();
      final newUser = await userService.createUser(userData);
      users.add(newUser);
      _showSuccess('User created successfully');
    } catch (e) {
      _handleError('Failed to create user: $e');
    } finally {
      _stopLoading();
    }
  }

  Future<void> updateUser(int userId, Map<String, dynamic> userData) async {
    try {
      _startLoading();
      final updatedUser = await userService.updateUser(userId, userData);

      // Update in users list if present
      final index = users.indexWhere((user) => user.id == userId);
      if (index != -1) {
        users[index] = updatedUser;
      }

      // If this is the current user, update auth controller and save to storage
      if (userId == currentUser.value?.id) {
        authController.user.value = updatedUser;
        await authController.storage.saveUser(updatedUser); // Save updated user
      }

      _showSuccess('User updated successfully');
    } catch (e) {
      _handleError('Failed to update user: $e');
    } finally {
      _stopLoading();
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      _startLoading();
      await userService.deleteUser(userId);
      users.removeWhere((user) => user.id == userId);
      _showSuccess('User deleted successfully');
    } catch (e) {
      _handleError('Failed to delete user: $e');
    } finally {
      _stopLoading();
    }
  }

  // Avatar methods
  Future<void> pickImageFromGallery(int userId) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        await updateAvatar(userId, image);
      }
    } catch (e) {
      _handleError('Failed to pick image: $e');
    }
  }

  Future<void> pickImageFromCamera(int userId) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        await updateAvatar(userId, image);
      }
    } catch (e) {
      _handleError('Failed to take photo: $e');
    }
  }

  Future<void> updateAvatar(int userId, XFile image) async {
    try {
      _startLoading();
      final updatedUser = await userService.updateAvatar(userId, image);

      // Update in users list if present
      final index = users.indexWhere((user) => user.id == userId);
      if (index != -1) {
        users[index] = updatedUser;
      }

      // If this is the current user, update auth controller
      if (userId == currentUser.value?.id) {
        authController.user.value = updatedUser;
        await authController.storage.saveUser(updatedUser); // Save updated user
      }

      _showSuccess('Profile picture updated successfully');
    } catch (e) {
      _handleError('Failed to upload image: $e');
    } finally {
      _stopLoading();
    }
  }

  Future<void> updatePassword(
    int userId, {
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _startLoading();
      await userService.updatePassword(
        userId,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      _showSuccess('Password updated successfully');
    } on HttpException catch (e) {
      _handleError(e.message);
    } catch (e) {
      _handleError('Failed to update password: $e');
    } finally {
      _stopLoading();
    }
  }

  // Preferences methods
  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    // TODO: Implement server-side notification preferences update
    _showSuccess('Notification preferences updated');
  }
}
