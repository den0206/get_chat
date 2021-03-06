import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_chat/src/screen/home/home_controller.dart';
import 'package:getx_chat/src/widgets/custom_button.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/Home';

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
        actions: [
          TextButton(
            onPressed: () {
              controller.auth.logout();
            },
            child: Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Text(controller.auth.current.name),
          ),
          CustomButton(
            title: "Loading",
            onPressed: () {
              controller.testLoading();
            },
          )
        ],
      ),
    );
  }
}
