import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import 'mode/grid.dart';
import 'mode/list.dart';

class UsersIndex extends GetView<UsersController> {
  UsersIndex({super.key});

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Get.toNamed('/users/create'),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('USERS'),
      actions: [
        Obx(() => IconButton(
              icon: Icon(
                  controller.isGridView.value ? Icons.list : Icons.grid_view),
              onPressed: () => controller.isGridView.toggle(),
              tooltip:
                  controller.isGridView.value ? 'Show as List' : 'Show as Grid',
            )),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        _buildPagination(),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value && controller.items.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.items.isEmpty) {
              return const Center(
                child: Text('No items found'),
              );
            }

            return RefreshIndicator(
              onRefresh: () => controller.refreshData(),
              child: controller.isGridView.value
                  ? UsersGridView(controller: controller)
                  : UsersListView(controller: controller),
            );
          }),
        ),
        _buildPagination(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search users...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
              controller.onSearch('');
            },
          ),
        ),
        onChanged: controller.onSearch,
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() => BasePagination(
            currentPage: controller.currentPage.value,
            totalPages: controller.totalPages.value,
            totalItems: controller.totalItems.value,
            itemsPerPage: controller.itemsPerPage.value,
            onPageChanged: (page) {
              controller.currentPage.value = page;
              controller.loadData();
            },
            onRowsPerPageChanged: (value) {
              if (value != null) {
                controller.itemsPerPage.value = value;
                controller.refreshData();
              }
            },
          )),
    );
  }
}
