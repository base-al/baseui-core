import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class ResetPasswordView extends GetView<AuthController> {
  ResetPasswordView({super.key});
  final config = Get.find<AppConfigBase>();

  static final _formKey =
      GlobalKey<FormState>(debugLabel: 'reset_password_form');
  late final _emailController = TextEditingController();
  late final _tokenController = TextEditingController();
  late final _passwordController = TextEditingController();
  late final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String? email = Get.parameters['email']?.trim();
    final String? token = Get.parameters['token']?.trim();

    // Pre-fill controllers if parameters exist and are valid
    if (email != null && GetUtils.isEmail(email)) {
      _emailController.text = email;
    }
    if (token != null) {
      _tokenController.text = token;
    }

    return AuthLayout(
      title: config.appName,
      subtitle: 'Create your new password',
      bulletPoints: const [
        'Password must be at least 6 characters',
        'Include numbers and letters',
        'Use special characters for better security',
        'Don\'t reuse old passwords',
      ],
      form: _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Reset Password',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Create a new password for your account:',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),
          // Email field
          TextFormField(
            controller: _emailController,
            readOnly: _emailController.text.isNotEmpty,
            enabled: _emailController.text.isEmpty,
            decoration: InputDecoration(
              labelText: 'Email Address',
              prefixIcon: const Icon(Icons.email_outlined),
              border: const OutlineInputBorder(),
              filled: _emailController.text.isNotEmpty,
              fillColor:
                  _emailController.text.isNotEmpty ? Colors.grey[100] : null,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address';
              }
              if (!GetUtils.isEmail(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Reset token field
          TextFormField(
            controller: _tokenController,
            readOnly: _tokenController.text.isNotEmpty,
            enabled: _tokenController.text.isEmpty,
            decoration: InputDecoration(
              labelText: 'Reset Code',
              prefixIcon: const Icon(Icons.key_outlined),
              border: const OutlineInputBorder(),
              filled: _tokenController.text.isNotEmpty,
              fillColor:
                  _tokenController.text.isNotEmpty ? Colors.grey[100] : null,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the reset code';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          // Password divider
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[300])),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'New Password',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey[300])),
            ],
          ),
          const SizedBox(height: 24),
          _buildPasswordFields(),
          const SizedBox(height: 24),
          _buildResetButton(),
          const SizedBox(height: 16),
          _buildErrorMessage(),
          _buildBackToLoginButton(),
        ],
      ),
    );
  }

  Widget _buildPasswordFields() {
    return Obx(() {
      return Column(
        children: [
          TextFormField(
            controller: _passwordController,
            obscureText: !controller.passwordVisible.value,
            decoration: InputDecoration(
              labelText: 'New Password',
              prefixIcon: const Icon(Icons.lock_outline),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.passwordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
              helperText:
                  'Password must be at least 6 characters with numbers and letters',
              helperMaxLines: 2,
            ),
            validator: _validatePassword,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: !controller.passwordVisible.value,
            decoration: const InputDecoration(
              labelText: 'Confirm New Password',
              prefixIcon: Icon(Icons.lock_outline),
              border: OutlineInputBorder(),
            ),
            validator: _validateConfirmPassword,
          ),
        ],
      );
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      controller.resetPassword(
        email: _emailController.text,
        code: _tokenController.text,
        newPassword: _passwordController.text,
      );
    }
  }

  Widget _buildResetButton() {
    return Obx(() => ElevatedButton(
          onPressed: controller.isLoading.value ? null : _handleSubmit,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Reset Password'),
        ));
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!value.contains(RegExp(r'[A-Za-z]'))) {
      return 'Password must contain at least one letter';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your new password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Widget _buildErrorMessage() {
    return Obx(() {
      if (controller.error.value.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          controller.error.value,
          style: TextStyle(
            color: config.errorColor,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      );
    });
  }

  Widget _buildBackToLoginButton() {
    return TextButton(
      onPressed: () => Get.offNamed('/auth/login'),
      child: const Text('Back to Login'),
    );
  }
}
