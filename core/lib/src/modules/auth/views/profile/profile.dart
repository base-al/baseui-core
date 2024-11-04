import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import 'dialogs.dart';

class ProfileView extends GetView<AuthController> {
  ProfileView({super.key});
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 1200;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isNarrow ? 16.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPageHeader(context),
              const SizedBox(height: 32),
              _buildProfileHeader(context),
              const SizedBox(height: 32),
              _buildGridLayout(context, isNarrow),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Settings',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage your account settings and preferences',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 32),
            Expanded(child: _buildUserInfo(context)),
            _buildStatusBadge(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarEditButton() {
    final theme = Theme.of(Get.context!);
    return Material(
      elevation: 4,
      shape: const CircleBorder(),
      color: theme.colorScheme.surface,
      child: InkWell(
        onTap: () => _showAvatarEditDialog(Get.context!),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.camera_alt,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Text(
              controller.user.value?.name ?? 'User',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            )),
        const SizedBox(height: 8),
        Obx(() => Text(
              controller.user.value?.username ?? '',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            )),
        const SizedBox(height: 8),
        Obx(() => Text(
              controller.user.value?.email ?? '',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            )),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
    required VoidCallback onEdit,
  }) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: theme.colorScheme.primary),
                    onPressed: onEdit,
                    tooltip: 'Edit $title',
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: theme.colorScheme.onSurface.withOpacity(0.1),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(Get.context!);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Hero(
      tag: 'profile-avatar',
      child: Stack(
        children: [
          Obx(() {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _buildAvatarImage(),
            );
          }),
          Positioned(
            right: 0,
            bottom: 0,
            child: _buildAvatarEditButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage() {
    if (controller.user.value?.avatar?.isNotEmpty ?? false) {
      return _buildNetworkAvatar();
    } else {
      return _buildInitialsAvatar();
    }
  }

  Widget _buildNetworkAvatar() {
    final theme = Theme.of(Get.context!);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() => CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(controller.user.value!.avatar!),
            onBackgroundImageError: (_, __) => _buildInitialsAvatar(),
          )),
    );
  }

  Widget _buildInitialsAvatar() {
    final theme = Theme.of(Get.context!);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: theme.colorScheme.primary,
        child: Text(
          controller.user.value?.name.substring(0, 1).toUpperCase() ?? '?',
          style: TextStyle(
            fontSize: 32,
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final theme = Theme.of(context);
    final successColor = theme.brightness == Brightness.dark
        ? Colors.green[400]
        : Colors.green[700];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: successColor?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: successColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Active',
            style: TextStyle(
              color: successColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridLayout(BuildContext context, bool isNarrow) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = isNarrow
            ? constraints.maxWidth
            : (constraints.maxWidth - (isNarrow ? 16.0 : 48.0)) / 3;

        return Wrap(
          spacing: isNarrow ? 16.0 : 24.0,
          runSpacing: isNarrow ? 16.0 : 24.0,
          children: [
            SizedBox(
              width: itemWidth,
              child: _buildPersonalInfo(context),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildSecuritySection(context),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildPreferencesSection(context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPersonalInfo(BuildContext context) {
    return Obx(() {
      return _buildSection(
        context,
        title: 'Personal Information',
        onEdit: () => _showPersonalInfoDialog(context),
        children: [
          _buildInfoRow(
            icon: Icons.person_outline,
            label: 'Name',
            value: controller.user.value?.name ?? '',
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.person_outline,
            label: 'Username',
            value: controller.user.value?.username ?? '',
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: controller.user.value?.email ?? '',
          ),
        ],
      );
    });
  }

  Widget _buildSecuritySection(BuildContext context) {
    return Obx(() {
      return _buildSection(
        context,
        title: 'Security',
        onEdit: () => _showChangePasswordDialog(context),
        children: [
          _buildInfoRow(
            icon: Icons.lock_outline,
            label: 'Password',
            value: '********',
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.access_time,
            label: 'Last Login',
            value: controller.user.value?.lastLogin?.toString() ?? 'Never',
          ),
        ],
      );
    });
  }

  Widget _buildPreferencesSection(BuildContext context) {
    return _buildSection(
      context,
      title: 'Preferences',
      onEdit: () => _showPreferencesDialog(context),
      children: [
        _buildInfoRow(
          icon: Icons.language,
          label: 'Language',
          value: 'English',
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          icon: Icons.notifications_outlined,
          label: 'Notifications',
          value: 'Enabled',
        ),
      ],
    );
  }

  void _showAvatarEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ProfileAvatarDialog(),
    );
  }

  void _showPersonalInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const PersonalInfoDialog(),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ChangePasswordDialog(),
    );
  }

  void _showPreferencesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const PreferencesDialog(),
    );
  }
}
