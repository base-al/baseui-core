import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../classes/theme_controller.dart';

class AnimatedDarkModeToggle extends StatelessWidget {
  const AnimatedDarkModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (controller) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return RotationTransition(
            turns: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        child: IconButton(
          key: ValueKey<bool>(controller.isDarkMode),
          icon: Icon(
            controller.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
            color: controller.textColor,
          ),
          onPressed: controller.toggleTheme,
          tooltip: controller.isDarkMode
              ? 'Switch to light mode'
              : 'Switch to dark mode',
        ),
      ),
    );
  }
}
