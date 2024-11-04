import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';

class ProfileAvatarDialog extends GetView<UserController> {
  const ProfileAvatarDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = controller.currentUser.value?.id;

    // If we don't have a user ID, we can't update the avatar
    if (userId == null) {
      Get.back();
      return const SizedBox.shrink();
    }

    return AlertDialog(
      title: const Text('Change Profile Picture'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () {
              Get.back();
              controller.pickImageFromGallery(userId);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a Photo'),
            onTap: () {
              Get.back();
              controller.pickImageFromCamera(userId);
            },
          ),
          if (controller.currentUser.value?.avatar != null)
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Remove Photo'),
              onTap: () {
                Get.back();
                // Note: Remove avatar functionality is not available in the API
                Get.snackbar(
                  'Error',
                  'This functionality is not available',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class PersonalInfoDialog extends GetView<UserController> {
  const PersonalInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController =
        TextEditingController(text: controller.currentUser.value?.name);
    final usernameController =
        TextEditingController(text: controller.currentUser.value?.username);
    final emailController =
        TextEditingController(text: controller.currentUser.value?.email);

    final userId = controller.currentUser.value?.id;

    // If we don't have a user ID, we can't update the info
    if (userId == null) {
      Get.back();
      return const SizedBox.shrink();
    }

    return AlertDialog(
      title: const Text('Edit Personal Information'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.alternate_email),
            ),
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            //
            controller.updateUser(
              userId,
              {
                'name': nameController.text,
                'username': usernameController.text,
                'email': emailController.text,
              },
            );
            Get.back();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class ChangePasswordDialog extends GetView<UserController> {
  const ChangePasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final userId = controller.currentUser.value?.id;

    // If we don't have a user ID, we can't update the password
    if (userId == null) {
      Get.back();
      return const SizedBox.shrink();
    }

    return AlertDialog(
      title: const Text('Change Password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: currentPasswordController,
            decoration: const InputDecoration(
              labelText: 'Current Password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: newPasswordController,
            decoration: const InputDecoration(
              labelText: 'New Password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: confirmPasswordController,
            decoration: const InputDecoration(
              labelText: 'Confirm New Password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final currentPassword = currentPasswordController.text.trim();
            final newPassword = newPasswordController.text.trim();
            final confirmPassword = confirmPasswordController.text.trim();

            if (currentPassword.isEmpty ||
                newPassword.isEmpty ||
                confirmPassword.isEmpty) {
              Get.snackbar(
                'Error',
                'All fields are required',
                snackPosition: SnackPosition.BOTTOM,
              );
              return;
            }

            if (newPassword != confirmPassword) {
              Get.snackbar(
                'Error',
                'Passwords do not match',
                snackPosition: SnackPosition.BOTTOM,
              );
              return;
            }

            controller.updatePassword(
              userId,
              currentPassword: currentPassword,
              newPassword: newPassword,
            );
            Get.back();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class PreferencesDialog extends GetView<UserController> {
  const PreferencesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Preferences'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Language'),
            subtitle: const Text('English'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Show language selection
            },
          ),
          Obx(() => SwitchListTile(
                title: const Text('Notifications'),
                subtitle: const Text('Receive push notifications'),
                value: controller.notificationsEnabled.value,
                onChanged: controller.toggleNotifications,
              )),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
