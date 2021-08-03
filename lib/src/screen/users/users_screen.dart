import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/screen/users/users_controller.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({
    Key? key,
    required this.isPrivate,
  }) : super(key: key);

  static const routeName = '/UsersScreen';
  final bool isPrivate;

  @override
  Widget build(BuildContext context) {
    return GetX<UsersController>(
      init: UsersController(isPrivate: isPrivate),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: isPrivate
                ? Text("Private")
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Group"),
                      Badge(
                          badgeColor: Colors.green,
                          animationType: BadgeAnimationType.slide,
                          showBadge: true,
                          toAnimate: true,
                          position: BadgePosition.topEnd(),
                          badgeContent: Text(
                            controller.selectedUsers.length.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          child: Icon(
                            Icons.person_add,
                            color: Colors.green,
                            size: 28,
                          ))
                    ],
                  ),
          ),
          body: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black,
              height: 1,
            ),
            itemCount: controller.users.length,
            itemBuilder: (BuildContext context, int index) {
              final user = controller.users[index];

              return UserCell(user: user);
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.green,
            onPressed: () {
              controller.createGroup();
            },
          ),
        );
      },
    );
  }
}

class UserCell extends GetView<UsersController> {
  const UserCell({
    Key? key,
    required this.user,
  }) : super(key: key);

  final FBUser user;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: controller.checkSelected(user)
            ? Colors.blue.withOpacity(0.3)
            : null,
        child: ListTile(
          leading: Hero(
            tag: user.uid,
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: user.imageUrl.isEmpty
                  ? Image.asset("assets/images/defaultDark.png").image
                  : NetworkImage(user.imageUrl),
              child: controller.checkSelected(user)
                  ? CircleAvatar(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.blue.withOpacity(0.3),
                    )
                  : null,
            ),
          ),
          title: Text(user.name),
          onTap: () {
            controller.onTap(user);
          },
        ),
      ),
    );
  }
}

// AssetImage("assets/images/defaultDark.png")
