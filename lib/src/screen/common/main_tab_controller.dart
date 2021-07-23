import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/screen/home/home_screen.dart';
import 'package:getx_chat/src/screen/users/users_screen.dart';

class MainTabController extends GetxController {
  final auth = Get.find<AuthController>();

  var currentIndex = 0;

  final bottomItems = [
    BottomNavigationBarItem(
      label: "Home",
      icon: Icon(
        Icons.home,
      ),
    ),
    BottomNavigationBarItem(
      label: "Users",
      icon: Icon(
        Icons.person,
      ),
    ),
  ];

  final List<Widget> pages = [
    HomeScreen(),
    UsersScreen(),
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    await checkuser();
  }

  @override
  void onClose() {
    super.onClose();
  }

  checkuser() async {
    if (auth.currentUser == null) {
      await auth.setCurrentUser();
      update();
      print("Call");
    }
  }

  void setIndex(int value) {
    currentIndex = value;
    update();
  }
}
