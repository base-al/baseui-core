// lib/app/routes/auth_routes.dart
import 'package:core/core.dart';
import 'package:get/get.dart';

import 'views/profile/profile.dart';

class AuthRoutes {
  // Make non-instantiable
  AuthRoutes._();

  // Route paths
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const forgotPassword = '/auth/forgot-password';
  static const resetPassword = '/auth/reset-password';
  static const profile = '/profile';

  // Helper method for reset password URL
  static String resetPasswordUrl(String email, String token) =>
      '/auth/reset-password/$email/$token';

  // Convert routes to BaseRoute list
  static final List<BaseRoute> routes = [
    BaseRoute(
      name: login,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    BaseRoute(
      name: register,
      page: () => RegisterView(),
      binding: AuthBinding(),
    ),
    BaseRoute(
      name: forgotPassword,
      page: () => ForgotPasswordView(),
      binding: AuthBinding(),
    ),
    BaseRoute(
      name: resetPassword,
      page: () => ResetPasswordView(),
      binding: AuthBinding(),
    ),
  ];

  // Separate protected routes that need App wrapper and middleware
  static final List<BaseRoute> protectedRoutes = [
    BaseRoute(
      name: profile,
      page: () => ProfileView(),
      binding: UserBinding(),
    ),
  ];

  // Combined routes
  static List<GetPage> get pages => [
        ...routes.map((r) => r.toGetPage()),
        ...protectedRoutes.map((r) => GetPage(
              name: r.name,
              page: () => r.page(),
              binding: r.binding,
              middlewares: [AuthMiddleware()],
            )),
      ];
}
