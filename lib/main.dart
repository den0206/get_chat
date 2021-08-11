import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/auth/login/login_screen.dart';
import 'package:getx_chat/src/screen/auth/signup/signup_controller.dart';
import 'package:getx_chat/src/screen/auth/signup/signup_screen.dart';
import 'package:getx_chat/src/screen/edit_user/edit_user_controller.dart';
import 'package:getx_chat/src/screen/edit_user/edit_user_screen.dart';
import 'package:getx_chat/src/screen/group_detail/group_detail_controller.dart';
import 'package:getx_chat/src/screen/group_detail/group_detail_screen.dart';
import 'package:getx_chat/src/screen/groups/groups_controller.dart';
import 'package:getx_chat/src/screen/groups/groups_screen.dart';
import 'package:getx_chat/src/screen/network_branch.dart/network_branch.dart';
import 'package:getx_chat/src/screen/home/home_screen.dart';
import 'package:getx_chat/src/screen/message/message_Controller.dart';
import 'package:getx_chat/src/screen/message/message_screen.dart';
import 'package:getx_chat/src/screen/root.dart';

import 'package:getx_chat/src/screen/users/users_screen.dart';

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
        appBarTheme: AppBarTheme(backgroundColor: Colors.grey),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.grey[300],
      ),
      getPages: [
        GetPage(
          name: NetworkBranch.routeName,
          page: () => NetworkBranch(),
        ),
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
          name: MessageScreen.routeName,
          page: () => MessageScreen(),
          binding: MessageBinding(),
        ),
        GetPage(
          name: UsersScreen.routeName,
          page: () => UsersScreen(
            isPrivate: false,
          ),
          fullscreenDialog: true,
        ),
        GetPage(
          name: GroupsScreen.routeName,
          page: () => GroupsScreen(),
          binding: GroupsBinding(),
        ),
        GetPage(
          name: EditUserScreen.routeName,
          page: () => EditUserScreen(),
          binding: EditUserBinding(),
        ),
        GetPage(
          name: GroupDetailScreen.routeName,
          page: () => GroupDetailScreen(),
          binding: GroupDetailBinding(),
        )
      ],

      initialRoute: NetworkBranch.routeName,
      // initialRoute: SignUpScreen.routeName,
    );
  }
}
