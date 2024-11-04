import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeIndex extends GetView<HomeController> {
  const HomeIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: false,
      ),
      body: const Center(
        child: Text(
          'HomeIndex is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
