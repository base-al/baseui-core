import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import '../services/user_service.dart';

class UsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserService>(() => UserService());
    Get.lazyPut<UsersController>(
      () => UsersController(userService: Get.find()),
    );
  }
}
