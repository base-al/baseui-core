// lib/main.dart
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';

import 'app/config.dart';
import 'app/routes.dart';
import 'app/theme.dart';

Future<void> main() async {
  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Set up web configuration
  setUrlStrategy(PathUrlStrategy());

  // Initialize storage
  await BaseStorage.initialize();

  // Initialize and register config
  final config = AppConfig();
  Get.put<AppConfigBase>(config, permanent: true);

  // Run the app
  runApp(const Albafone());
}

class Albafone extends StatelessWidget {
  const Albafone({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Get.find<AppConfigBase>();

    return GetMaterialApp(
      title: config.appName,
      navigatorKey: Get.key,
      initialBinding: BaseBindings(),
      initialRoute: CoreRoutes.splash,
      getPages: AppRoutes.allRoutes,
      enableLog: true,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 0),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
    );
  }
}
