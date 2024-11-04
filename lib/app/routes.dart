// lib/app/routes.dart
import 'package:core/core.dart';
import 'package:get/get.dart';

import '../modules/users/routes.dart';
import 'app.dart';

// MODULE IMPORTS
class AppRoutes {
  AppRoutes._();

  // Module routes (all protected)
  static final List<BaseRoute> moduleRoutes = [
    ...UsersRoutes.routes,

// MODULE PAGES
  ];

  // Helper method to convert protected route to GetPage with App wrapper
  static GetPage _wrapWithApp(BaseRoute route) {
    return GetPage(
      name: route.name,
      page: () => App(page: route.page()),
      binding: route.binding,
      middlewares: [AuthMiddleware()],
      transition: route.transition,
      transitionDuration: route.transitionDuration,
      curve: route.curve,
      opaque: route.opaque,
      maintainState: route.maintainState ?? true,
    );
  }

  // Get all routes combined and properly configured
  static List<GetPage> get allRoutes {
    // Convert public routes (no App wrapper)
    final publicPages =
        CoreRoutes.publicRoutes.map((route) => route.toGetPage()).toList();

    // Convert all protected routes (both core and app) with App wrapper
    final protectedPages = [
      ...CoreRoutes.protectedRoutes, // Home and other core protected routes
      ...moduleRoutes, // App module routes
    ].map(_wrapWithApp).toList();

    return [
      ...publicPages,
      ...protectedPages,
    ];
  }
}
