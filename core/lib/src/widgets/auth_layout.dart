// lib/app/modules/auth/views/components/auth_layout.dart
import 'package:flutter/material.dart';

import 'base/svg_logo.dart';

class AuthLayout extends StatelessWidget {
  final Widget form;
  final String title;
  final String subtitle;
  final bool showLogo;
  final List<String>? bulletPoints;
  final Color? logoColor;

  const AuthLayout({
    super.key,
    required this.form,
    required this.title,
    required this.subtitle,
    this.showLogo = true,
    this.bulletPoints,
    this.logoColor,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 768;
    return isWeb ? _buildWebLayout(context) : _buildMobileLayout(context);
  }

  Widget _buildWebLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side - Branding/Info section
          Expanded(
            flex: 5,
            child: Container(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              padding: const EdgeInsets.all(48.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showLogo) ...[
                    SvgLogo(
                      height: 60,
                      color: logoColor ?? Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 48),
                  ],
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  if (bulletPoints != null) ...[
                    const SizedBox(height: 32),
                    ...bulletPoints!.map((point) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  point,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: Colors.grey[700]),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ],
              ),
            ),
          ),
          // Right side - Form section
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(48.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: SingleChildScrollView(
                    child: form,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                if (showLogo) ...[
                  Center(
                    child: SvgLogo(
                      height: 40,
                      color: logoColor ?? Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                form,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
