import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'navbar.dart';

class App extends StatelessWidget {
  final Widget page;

  const App({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      headerWidgets: [
        SvgLogo(
          height: 30,
          color: Theme.of(context).primaryColor,
        ),
        const Spacer(),
        const AnimatedDarkModeToggle(),
        UserMenu(),
      ],
      navigationItems: destinations,
      drawerHeader: _buildDrawerHeader(context),
      drawerFooter: _buildDrawerFooter(),
      body: page,
      footerWidgets: [
        Text('BaseUI™ © 2024 Basecode LLC. All rights reserved.'),
        Row(
          children: [
            IconButton(icon: Icon(Icons.facebook), onPressed: () {}),
            IconButton(icon: Icon(Icons.girl), onPressed: () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildDrawerHeader(context) {
    return DrawerHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgLogo(
            height: 30,
            color: Theme.of(context).primaryColor,
          ),
          const Spacer(),
          UserMenu(),
        ],
      ),
    );
  }

  Widget _buildDrawerFooter() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: AnimatedDarkModeToggle(),
    );
  }
}
