import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
import '../../models/user.dart';

class UsersListView extends StatelessWidget {
  final UsersController controller;

  const UsersListView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: controller.items.length,
      itemBuilder: (context, index) {
        final item = controller.items[index];
        return _buildListItem(item);
      },
    );
  }

  Widget _buildListItem(User item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: _buildAvatar(item),
        title: Text(
          item.name?.toString() ?? 'No Name'
        ),
        subtitle: Text(
          item.email?.toString() ?? 'No Email'
        ),
        trailing: _buildActions(item),
        onTap: () => Get.toNamed('/users/show/${item.id}', arguments: item),
      ),
    );
  }

  Widget _buildAvatar(User item) {
    return CircleAvatar(
      backgroundColor: Colors.blue.shade100,
      child: Text(
        item.name?.toString()[0].toUpperCase() ?? '?',
        style: TextStyle(color: Colors.blue.shade700),
      ),
    );
  }

  Widget _buildActions(User item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => Get.toNamed('/users/edit/${item.id}', arguments: item),
          color: Colors.orange,
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _confirmDelete(item),
          color: Colors.red,
        ),
      ],
    );
  }

  void _confirmDelete(User item) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteUser(item.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}