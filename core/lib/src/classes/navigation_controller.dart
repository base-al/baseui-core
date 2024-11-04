// lib/core/classes/navigation_controller.dart
import 'package:get/get.dart';

import '../widgets/navigation.dart';

class NavigationController extends GetxController {
  RxInt selectedIndex = 110.obs;

  void setViewByIndex(int index, List<NavLink> destinations) {
    final path = destinations[index].path;
    Get.toNamed(
      path,
    );
  }
}
