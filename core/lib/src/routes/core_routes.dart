// core/lib/src/routes/core_routes.dart
import 'package:core/core.dart';
import 'package:core/src/modules/auth/routes.dart';
import 'package:core/src/modules/home/routes.dart';

class CoreRoutes {
  CoreRoutes._();

  static const splash = '/';

  // Public routes (no auth required)
  static final List<BaseRoute> publicRoutes = [
    BaseRoute(
      name: splash,
      page: () => Splash(),
      binding: SplashBinding(),
    ),
    ...AuthRoutes.routes,
  ];

  // Protected routes (auth required)
  static final List<BaseRoute> protectedRoutes = [
    ...HomeRoutes.routes,
    ...AuthRoutes.protectedRoutes,
  ];
}
