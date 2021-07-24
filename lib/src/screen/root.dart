import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/screen/auth/login/login_screen.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/common/main_tab_screen.dart';
import 'package:getx_chat/src/screen/widgets/loading_widget.dart';

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);
  static const routeName = '/Root';

  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
      init: AuthController(),
      builder: (controller) {
        if (controller.user.value != null) {
          // if (controller.currentUser != null) {
          //   return MainTabScreen();
          // }

          return FutureBuilder(
            future: controller.setCurrentUser(),
            builder: (context, snapshot) {
              if (controller.currentUser != null) {
                return MainTabScreen();
              }
              return PlainLoadingWidget();
            },
          );
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
