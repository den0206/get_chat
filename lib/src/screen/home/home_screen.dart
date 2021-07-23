import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/screen/home/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/Home';

  @override
  Widget build(BuildContext context) {
    if (controller.auth.currentUser == null) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
        actions: [
          TextButton(
            onPressed: () {
              final auth = Get.find<AuthController>();
              auth.logout();
            },
            child: Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Center(
        child: Text(current.name),
      ),
    );
  }
}
