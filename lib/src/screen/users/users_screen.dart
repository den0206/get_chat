import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/screen/users/users_controller.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';
import 'package:getx_chat/src/widgets/custom_dialog.dart';

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
            title: isPrivate ? Text("Private") : Text("Group"),
            actions: !isPrivate
                ? [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Badge(
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
                        ),
                      ),
                    )
                  ]
                : null,
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
          floatingActionButton: !isPrivate
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  backgroundColor: Colors.green,
                  onPressed: () {
                    Get.dialog(CustomDialog(
                      title: "Group",
                      descripon: "create group?",
                      icon: Icons.group_add,
                      mainColor: Colors.green,
                      onSuceed: () {
                        controller.createGroup();
                      },
                    ));
                  },
                )
              : null,
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
              backgroundImage: getUserImage(user),
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
