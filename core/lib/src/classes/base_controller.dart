// core/classes/base_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseController<T> extends GetxController {
  // Abstract properties that must be implemented by child classes
  String get entityName;
  List<String> get sortableColumns;
  T itemFromJson(Map<String, dynamic> json);

  // Observable states
  final items = <T>[].obs;
  final totalItems = 0.obs;
  final isLoading = false.obs;
  final currentPage = 1.obs;
  final itemsPerPage = 10.obs;
  final currentSort = 'id'.obs;
  final currentOrder = 'desc'.obs;
  final searchQuery = ''.obs;
  final RxSet<String> activeFilters = <String>{}.obs;
  final RxInt perPage = 10.obs;

  // Error handling
  final error = Rxn<String>();

  // Required methods to be implemented by child classes
  Future<Map<String, dynamic>> fetchItems({
    required int page,
    required int limit,
    required String sort,
    required String order,
    required String search,
  });
  void exportToCsv() {
    // Implement CSV export
  }

  void exportToExcel() {
    // Implement Excel export
  }

  Future<bool> createItem(T item);
  Future<bool> updateItem(int id, T item);
  Future<bool> deleteItem(int id);

  // Initialize the controller
  @override
  void onInit() {
    super.onInit();
    // Initial load of items
    refreshItems();

    // Set up reaction to monitor changes that should trigger a refresh
    ever(currentPage, (_) => refreshItems());
    ever(itemsPerPage, (_) => refreshItems());
    ever(currentSort, (_) => refreshItems());
    ever(currentOrder, (_) => refreshItems());
    debounce(
      searchQuery,
      (_) => refreshItems(),
      time: const Duration(milliseconds: 500),
    );
  }

  void setPerPage(int value) {
    itemsPerPage.value = value;
    currentPage.value = 1; // Reset to first page when changing items per page
    refreshItems();
  }

  // Refresh items with current pagination and sorting
  Future<void> refreshItems() async {
    try {
      isLoading.value = true;
      error.value = null;

      final result = await fetchItems(
        page: currentPage.value,
        limit: itemsPerPage.value,
        sort: currentSort.value,
        order: currentOrder.value,
        search: searchQuery.value,
      );

      totalItems.value = result['total'];
      items.assignAll(
        (result['items'] as List).map((item) => itemFromJson(item)).toList(),
      );
    } catch (e) {
      error.value = 'Failed to load ${entityName.toLowerCase()}s: $e';
      Get.snackbar(
        'Error',
        'Failed to load ${entityName.toLowerCase()}s',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Create and save a new item
  Future<bool> createAndSave(T item) async {
    try {
      isLoading.value = true;
      error.value = null;

      final success = await createItem(item);
      if (success) {
        Get.snackbar(
          'Success',
          '$entityName created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        refreshItems();
        return true;
      }
      return false;
    } catch (e) {
      error.value = 'Failed to create $entityName: $e';
      Get.snackbar(
        'Error',
        'Failed to create $entityName',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update an existing item
  Future<bool> updateAndSave(int id, T item) async {
    try {
      isLoading.value = true;
      error.value = null;

      final success = await updateItem(id, item);
      if (success) {
        Get.snackbar(
          'Success',
          '$entityName updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        refreshItems();
        return true;
      }
      return false;
    } catch (e) {
      error.value = 'Failed to update $entityName: $e';
      Get.snackbar(
        'Error',
        'Failed to update $entityName',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete an item
  Future<bool> deleteAndRemove(int id) async {
    try {
      isLoading.value = true;
      error.value = null;

      final success = await deleteItem(id);
      if (success) {
        Get.snackbar(
          'Success',
          '$entityName deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        refreshItems();
        return true;
      }
      return false;
    } catch (e) {
      error.value = 'Failed to delete $entityName: $e';
      Get.snackbar(
        'Error',
        'Failed to delete $entityName',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Pagination helpers
  void nextPage() {
    if (hasNextPage) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (hasPreviousPage) {
      currentPage.value--;
    }
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      currentPage.value = page;
    }
  }

  // Sorting helpers
  void setSort(String column) {
    if (sortableColumns.contains(column)) {
      if (currentSort.value == column) {
        currentOrder.value = currentOrder.value == 'asc' ? 'desc' : 'asc';
      } else {
        currentSort.value = column;
        currentOrder.value = 'asc';
      }
    }
  }

  // Search helper
  void setSearch(String query) {
    searchQuery.value = query;
    currentPage.value = 1; // Reset to first page when searching
  }

  // Computed properties
  bool get hasNextPage =>
      currentPage.value * itemsPerPage.value < totalItems.value;

  bool get hasPreviousPage => currentPage.value > 1;

  int get totalPages => (totalItems.value / itemsPerPage.value).ceil();

  List<int> get availablePages {
    const maxVisiblePages = 5;
    final total = totalPages;
    final current = currentPage.value;

    if (total <= maxVisiblePages) {
      return List.generate(total, (i) => i + 1);
    }

    final pages = <int>[];
    if (current <= 3) {
      pages.addAll(List.generate(4, (i) => i + 1));
      pages.add(total);
    } else if (current >= total - 2) {
      pages.add(1);
      pages.addAll(List.generate(4, (i) => total - 3 + i));
    } else {
      pages.add(1);
      pages.addAll(List.generate(3, (i) => current - 1 + i));
      pages.add(total);
    }
    return pages;
  }
}
