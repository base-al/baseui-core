import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import '../models/user.dart';

class UserShow extends GetView<UsersController> {
  const UserShow({super.key});

  @override
  Widget build(BuildContext context) {
    final User user = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('User Details: ${user.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Get.toNamed(
              '/users/edit/${user.id}',
              arguments: user,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => Get.dialog(
              AlertDialog(
                title: const Text('Confirm Delete'),
                content: Text(
                  'Are you sure you want to delete ${user.name}?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                      controller.deleteUser(user.id);
                      Get.back();
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(
              context,
              title: 'Basic Information',
              children: [
                _buildInfoRow('ID', user.id.toString()),
                _buildInfoRow('Name', user.name?.toString() ?? 'N/A'),
                _buildInfoRow('Email', user.email?.toString() ?? 'N/A'),
                _buildInfoRow('Username', user.username?.toString() ?? 'N/A'),
                _buildInfoRow('Avatar', user.avatar?.toString() ?? 'N/A'),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: 'Additional Details',
              children: [
                _buildInfoRow(
                  'Created At',
                  user.createdAt.toLocal().toString(),
                ),
                _buildInfoRow(
                  'Updated At',
                  user.updatedAt.toLocal().toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
