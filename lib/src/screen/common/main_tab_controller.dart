import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/screen/home/home_screen.dart';
import 'package:getx_chat/src/screen/news/news_screen.dart';
import 'package:getx_chat/src/screen/recent/recents_screen.dart';
import 'package:getx_chat/src/screen/users/users_screen.dart';

class MainTabController extends GetxController {
  static MainTabController get to => Get.find();
  final auth = Get.find<AuthController>();

  /// for fullscreen overlay
  final RxBool isLoading = false.obs;

  var currentIndex = 0;

  final bottomItems = [
    BottomNavigationBarItem(
      label: "Chats",
      icon: Icon(Icons.message),
    ),
    BottomNavigationBarItem(
      label: "News",
      icon: Icon(Icons.pages),
    ),
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
    RecentsScreen(),
    NewsScreen(),
    HomeScreen(),
    UsersScreen(
      isPrivate: true,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void setIndex(int value) {
    currentIndex = value;
    update();
  }

  void setLoading(bool value) {
    isLoading.value = value;
    update();
  }
}
