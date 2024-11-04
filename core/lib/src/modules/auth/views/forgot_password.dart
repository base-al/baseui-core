// lib/app/modules/auth/views/forgot_password_view.dart
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class ForgotPasswordView extends GetView<AuthController> {
  ForgotPasswordView({super.key});
  final config = Get.find<AppConfigBase>();
  final _formKey = GlobalKey<FormState>(debugLabel: 'forgot_password_form');
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: config.appName,
      subtitle: 'Reset your password',
      bulletPoints: const [
        'Enter your email address',
        'We\'ll send you a reset link',
        'Check your spam folder if you don\'t see the email',
        'The link expires in 24 hours',
      ],
      form: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Forgot Password',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Enter your email address and we\'ll send you instructions to reset your password.',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            _buildEmailField(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
            const SizedBox(height: 16),
            _buildErrorMessage(),
            TextButton(
              onPressed: () => Get.offNamed('/auth/reset-password'),
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email_outlined),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!GetUtils.isEmail(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () {
                  if (_formKey.currentState?.validate() ?? false) {
                    controller.forgotPassword(_emailController.text);
                  }
                },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Send Reset Link'),
        ));
  }

  Widget _buildErrorMessage() {
    return Obx(() {
      if (controller.error.value.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          controller.error.value,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    });
  }
}
