import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user.dart';
import '../services/user_service.dart';

class UsersController extends GetxController {
  final UserService userService;

  final isLoading = false.obs;
  final items = <User>[].obs;
  final totalItems = 0.obs;
  final currentPage = 1.obs;
  final itemsPerPage = 10.obs;
  final totalPages = 0.obs;
  final searchQuery = ''.obs;
  final isGridView = false.obs;

  UsersController({required this.userService});

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  Future<void> refreshData() async {
    currentPage.value = 1;
    await loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;

    try {
      final response = await userService.getUsers(
        page: currentPage.value,
        limit: itemsPerPage.value,
        search: searchQuery.value,
      );

      if (response.body == null) throw 'No response data';

      final data = response.body!['data'] as List;
      final pagination = response.body!['pagination'] as Map<String, dynamic>;

      items.value = data
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
      totalItems.value = pagination['total'] as int;
      totalPages.value = pagination['total_pages'] as int;
    } catch (e) {
      _showError('Failed to load users', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createUser(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final item = User.fromJson(data);
      final response = await userService.createUser(item);

      if (response.isOk) {
        await refreshData();
        Get.back();
        _showSuccess('User created successfully');
      } else {
        throw response.statusText ?? 'Failed to create';
      }
    } catch (e) {
      _showError('Failed to create user', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(int id, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final item = User.fromJson(data);
      final response = await userService.updateUser(id, item);

      if (response.isOk) {
        await refreshData();
        Get.back();
        _showSuccess('User updated successfully');
      } else {
        throw response.statusText ?? 'Failed to update';
      }
    } catch (e) {
      _showError('Failed to update user', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      isLoading.value = true;
      final response = await userService.deleteUser(id);

      if (response.isOk) {
        await refreshData();
        _showSuccess('User deleted successfully');
      } else {
        throw response.statusText ?? 'Failed to delete';
      }
    } catch (e) {
      _showError('Failed to delete user', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<User?> getUser(int id) async {
    try {
      isLoading.value = true;
      final response = await userService.getUser(id);

      if (response.isOk && response.body != null) {
        return User.fromJson(response.body as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      _showError('Failed to get user', e);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void updateItemOrder(int oldIndex, int newIndex) {
    // Get current item
    final item = items[oldIndex];

    // Update local list first
    items.removeAt(oldIndex);
    items.insert(newIndex, item);

    // Create sorted IDs list
    final List<int> sortedIds = items.map((item) => item.id).toList();

    // Update in backend
    _updateSortOrder(sortedIds);
  }

  Future<void> _updateSortOrder(List<int> sortedIds) async {
    try {
      isLoading.value = true;
      final response = await userService.updateSort(sortedIds);

      if (!response.isOk) {
        throw response.statusText ?? 'Failed to update sort order';
      }
    } catch (e) {
      _showError('Failed to update sort order', e);
      // Optionally refresh data to ensure consistency
      await refreshData();
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch(String query) {
    searchQuery.value = query;
    refreshData();
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showError(String message, dynamic error) {
    Get.snackbar(
      'Error',
      '$message: $error',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
    );
  }
}
