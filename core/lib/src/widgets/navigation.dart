import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../classes/navigation_controller.dart';

class NavLink {
  final Icon icon;
  final String label;
  final String path;

  NavLink({
    required this.icon,
    required this.label,
    required this.path,
  });
}

class Navigation extends StatelessWidget {
  final List<NavLink> destinations;
  final double width;
  final Widget? leading;
  final Widget? trailing;

  const Navigation({
    super.key,
    required this.destinations,
    required this.width,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController =
        Get.find<NavigationController>();
    final colorScheme = Theme.of(context).colorScheme;
    final currentRoute = Get.currentRoute;
    final isExpanded = width > 72;

    return Obx(() => SizedBox(
          width: width,
          child: Column(
            children: [
              if (leading != null) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isExpanded ? 16 : 8,
                    vertical: 8,
                  ),
                  child: leading!,
                ),
              ],
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: List.generate(destinations.length, (index) {
                    final isSelected =
                        destinations[index].path == currentRoute ||
                            index == navigationController.selectedIndex.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: InkWell(
                        onTap: () {
                          navigationController.setViewByIndex(
                              index, destinations);
                          navigationController.selectedIndex.value = index;
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: width - 16,
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: isExpanded ? 16 : 0,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.secondaryContainer
                                : null,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: isExpanded
                              ? Row(
                                  children: [
                                    IconTheme(
                                      data: IconThemeData(
                                        color: isSelected
                                            ? colorScheme.onSecondaryContainer
                                            : colorScheme.onSurfaceVariant,
                                        size: 24,
                                      ),
                                      child: destinations[index].icon,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        destinations[index].label,
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 14,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? colorScheme.onSecondaryContainer
                                              : colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconTheme(
                                      data: IconThemeData(
                                        color: isSelected
                                            ? colorScheme.onSecondaryContainer
                                            : colorScheme.onSurfaceVariant,
                                        size: 24,
                                      ),
                                      child: destinations[index].icon,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      destinations[index].label,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 12,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? colorScheme.onSecondaryContainer
                                            : colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isExpanded ? 16 : 8,
                    vertical: 8,
                  ),
                  child: trailing!,
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ));
  }
}
