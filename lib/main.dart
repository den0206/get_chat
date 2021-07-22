import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/auth/login/login_controller.dart';
import 'package:getx_chat/src/screen/auth/login/login_screen.dart';
import 'package:getx_chat/src/screen/auth/signup/signup_controller.dart';
import 'package:getx_chat/src/screen/auth/signup/signup_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Getx Chat',
      defaultTransition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 230),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.grey[300],
      ),
      getPages: [
        GetPage(
          name: LoginScreen.routeName,
          page: () => LoginScreen(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: SignUpScreen.routeName,
          page: () => SignUpScreen(),
          binding: SignupBinding(),
        )
      ],
      initialRoute: LoginScreen.routeName,
    );
  }
}
