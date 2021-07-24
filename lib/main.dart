import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/auth/login/login_screen.dart';
import 'package:getx_chat/src/screen/auth/signup/signup_controller.dart';
import 'package:getx_chat/src/screen/auth/signup/signup_screen.dart';
import 'package:getx_chat/src/screen/home/home_screen.dart';
import 'package:getx_chat/src/screen/root.dart';
import 'package:getx_chat/src/screen/user_detail/user_detail_controller.dart';
import 'package:getx_chat/src/screen/user_detail/user_detail_sceen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
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
          name: Root.routeName,
          page: () => Root(),
        ),
        GetPage(
          name: LoginScreen.routeName,
          page: () => LoginScreen(),
          // binding: LoginBinding(),
        ),
        GetPage(
          name: SignUpScreen.routeName,
          page: () => SignUpScreen(),
          binding: SignupBinding(),
        ),
        GetPage(
          name: HomeScreen.routeName,
          page: () => HomeScreen(),
        ),
        GetPage(
          name: UserDetailScreen.routeName,
          page: () => UserDetailScreen(),
          binding: UserDetailBinding(),
        )
      ],
      initialRoute: Root.routeName,
      // initialRoute: SignUpScreen.routeName,
    );
  }
}
