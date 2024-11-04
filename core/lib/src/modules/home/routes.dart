import 'package:core/core.dart';
import 'package:get/get.dart';

import 'views/home_view.dart';

class HomeRoutes {
  // Make non-instantiable
  HomeRoutes._();

  static const index = '/home';

  static final List<BaseRoute> routes = [
    BaseRoute(
      name: index,
      page: () => HomeIndex(),
      binding: HomeBinding(),
    ),
  ];

  // Helper method to get GetPages if needed
  static List<GetPage> get pages => routes.map((r) => r.toGetPage()).toList();
}
