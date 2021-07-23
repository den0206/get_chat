import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
        actions: [
          TextButton(
              onPressed: () {
                print("logout");
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Center(
        child: Text(
          ctr.user.value?.uid ?? "No",
        ),
      ),
    );
  }
}
