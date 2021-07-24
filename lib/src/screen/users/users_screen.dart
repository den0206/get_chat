import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/screen/user_detail/user_detail_sceen.dart';
import 'package:getx_chat/src/screen/users/users_controller.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<UsersController>(
        init: UsersController(),
        builder: (controller) {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemCount: controller.users.length,
            itemBuilder: (BuildContext context, int index) {
              final user = controller.users[index];

              return UserCell(user: user);
            },
          );
        },
      ),
    );
  }
}

class UserCell extends StatelessWidget {
  const UserCell({
    Key? key,
    required this.user,
  }) : super(key: key);

  final FBUser user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: user.uid,
        child: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: user.imageUrl.isEmpty
              ? Image.asset("assets/images/defaultDark.png").image
              : NetworkImage(user.imageUrl),
        ),
      ),
      title: Text(user.name),
      onTap: () {
        Get.toNamed(UserDetailScreen.routeName, arguments: user);
      },
    );
  }
}

// AssetImage("assets/images/defaultDark.png")
