import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../modules/users/routes.dart';
// MODULE IMPORTS

final List<NavLink> destinations = [
  NavLink(icon: Icon(Icons.home), label: 'Home', path: '/home'),
  NavLink(
    icon: Icon(Icons.admin_panel_settings_outlined),
    label: 'Users',
    path: UsersRoute.list,
  ),
];
