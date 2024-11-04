import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../routes.dart';

class UserMenu extends GetView<AuthController> {
  UserMenu({super.key});
  final config = Get.find<AppConfigBase>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PopupMenuButton<String>(
        offset: const Offset(0, -120),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<String>(
            enabled: false,
            height: 80,
            child: _buildUserHeader(),
          ),
          _buildMenuItem(
            value: 'profile',
            icon: Icons.person_outline,
            label: 'Profile',
          ),
          _buildMenuItem(
            value: 'logout',
            icon: Icons.logout,
            label: 'Logout',
            isDestructive: true,
          ),
        ],
        onSelected: _handleMenuSelection,
        child: _buildUserAvatar(),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
      ),
      child: Obx(() {
        if (controller.user.value?.avatar?.isNotEmpty ?? false) {
          return CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(controller.user.value!.avatar!),
            backgroundColor: Colors.grey[200],
          );
        } else {
          return CircleAvatar(
            radius: 20,
            backgroundColor: config.primaryColor,
            child: Text(
              controller.user.value?.name.substring(0, 1).toUpperCase() ?? '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      }),
    );
  }

  Widget _buildUserHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Text(
              controller.user.value?.name ?? 'User',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )),
        const SizedBox(height: 4),
        Obx(() => Text(
              controller.user.value?.email ?? '',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            )),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required IconData icon,
    required String label,
    bool isDestructive = false,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDestructive ? config.errorColor : null,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isDestructive ? config.errorColor : null,
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'profile':
        Get.toNamed(AuthRoutes.profile); // Use AuthRoutes.profile
        break;

      case 'logout':
        _showLogoutDialog();
        break;
    }
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: Text(
              'Logout',
              style: TextStyle(color: config.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
