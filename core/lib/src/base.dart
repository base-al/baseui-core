import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/navigation.dart';

class BaseLayout extends StatelessWidget {
  final Widget body;
  final List<Widget> headerWidgets;
  final List<NavLink> navigationItems;
  final List<Widget> footerWidgets;
  final Widget? drawerHeader;
  final Widget? drawerFooter;
  final Widget? navigationLeading;
  final Widget? navigationTrailing;

  const BaseLayout({
    super.key,
    required this.body,
    this.headerWidgets = const [],
    this.navigationItems = const [],
    this.footerWidgets = const [],
    this.drawerHeader,
    this.drawerFooter,
    this.navigationLeading,
    this.navigationTrailing,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 1200;
    final isTablet = width > 600 && width <= 1200;
    final isMobile = width <= 600;

    return Scaffold(
      appBar: AppBar(
        title: Row(children: headerWidgets),
        automaticallyImplyLeading: isMobile,
      ),
      drawer: isMobile ? _buildNavigationDrawer(context) : null,
      body: Row(
        children: [
          if (!isMobile)
            _buildNavigation(
              context: context,
              isDesktop: isDesktop,
              isTablet: isTablet,
            ),
          Expanded(
            child: Column(
              children: [
                Expanded(child: body),
                if (footerWidgets.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: footerWidgets,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation({
    required BuildContext context,
    required bool isDesktop,
    required bool isTablet,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: isTablet
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                ),
              ]
            : null,
        border: isDesktop
            ? Border(
                right: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              )
            : null,
      ),
      child: Navigation(
        destinations: navigationItems,
        width: isDesktop ? 240 : 72,
        leading: navigationLeading,
        trailing: navigationTrailing,
      ),
    );
  }

  Widget _buildNavigationDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          if (drawerHeader != null) drawerHeader!,
          if (navigationLeading != null) navigationLeading!,
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: navigationItems.map((item) {
                return ListTile(
                  leading: item.icon,
                  title: Text(item.label),
                  onTap: () {
                    Get.toNamed(item.path);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
          if (navigationTrailing != null) navigationTrailing!,
          if (drawerFooter != null) drawerFooter!,
        ],
      ),
    );
  }
}
