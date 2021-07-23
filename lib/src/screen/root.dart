import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/screen/auth/login/login_screen.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/common/main_tab_screen.dart';
import 'package:getx_chat/src/screen/home/home_controller.dart';

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);
  static const routeName = '/Root';

  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
      init: AuthController(),
      builder: (controller) {
        if (controller.user.value?.uid != null) {
          Get.put(HomeController());
          return MainTabScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
