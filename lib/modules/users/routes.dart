import 'package:core/core.dart';

import 'bindings/user_binding.dart';
import 'views/create.dart';
import 'views/edit.dart';
import 'views/index.dart';
import 'views/show.dart';

class UsersRoutes {
  static final routes = [
    BaseRoute(
      name: UsersRoute.list,
      page: () => UsersIndex(),
      binding: UsersBinding(),
    ),
    BaseRoute(
      name: UsersRoute.create,
      page: () => UserCreate(),
      binding: UsersBinding(),
    ),
    BaseRoute(
      name: UsersRoute.edit,
      page: () => UserEdit(),
      binding: UsersBinding(),
    ),
    BaseRoute(
      name: UsersRoute.show,
      page: () => const UserShow(),
      binding: UsersBinding(),
    ),
  ];
}

abstract class UsersRoute {
  UsersRoute._();

  static const list = '/users';
  static const create = '/users/create';
  static const edit = '/users/edit/:id';
  static const show = '/users/show/:id';

  // Helper methods for dynamic routes
  static String editPath(int id) => '/users/edit/$id';
  static String showPath(int id) => '/users/show/$id';
}
