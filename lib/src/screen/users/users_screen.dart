import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/users/users_controller.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<UsersController>(
        init: UsersController(),
        builder: (controller) {
          return ListView.builder(
            itemCount: controller.users.length,
            itemBuilder: (BuildContext context, int index) {
              final user = controller.users[index];

              return ListTile(
                title: Text(user.name),
              );
            },
          );
        },
      ),
    );
  }
}
