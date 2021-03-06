import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/screen/edit_user/edit_user_screen.dart';

import 'package:getx_chat/src/screen/groups/groups_screen.dart';
import 'package:getx_chat/src/screen/network_branch.dart/network_branch.dart';
import 'package:getx_chat/src/screen/user_detail/user_detail_controller.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';
import 'package:getx_chat/src/widgets/custom_dialog.dart';
import 'package:getx_chat/src/widgets/detail_profile_space.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  static const routeName = '/UserDetail';
  final FBUser user;

  @override
  Widget build(BuildContext context) {
    final Size responsive = MediaQuery.of(context).size;

    return GetBuilder<UserDetailController>(
      init: UserDetailController(user: user.obs),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.user.value.name),
          ),
          body: BaseScreen(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.zero,
                        height: responsive.height * 0.2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              "https://picsum.photos/500/200",
                            ),
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            repeat: ImageRepeat.noRepeat,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: kToolbarHeight + 20,
                          ),
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 70, 10, 10),
                                padding: EdgeInsets.only(
                                  top: responsive.height * 0.05,
                                  bottom: responsive.height * 0.03,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      controller.user.value.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 40.0,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: responsive.height * 0.02,
                                    ),
                                    Text(
                                      controller.user.value.email,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: responsive.height * 0.03,
                                    ),
                                    DetailButtonSpace(
                                      actions: controller.user.value.isCurrent
                                          ? [
                                              DetailIconButton(
                                                icon: Icons.group,
                                                backColor: Colors.orange,
                                                onTap: () {
                                                  Get.toNamed(
                                                      GroupsScreen.routeName);
                                                },
                                              ),
                                              DetailIconButton(
                                                  icon: Icons.settings,
                                                  onTap: () async {
                                                    final editedUser =
                                                        await Get.toNamed(
                                                            EditUserScreen
                                                                .routeName);

                                                    if (editedUser != null) {
                                                      controller
                                                          .updateEditedUser(
                                                              editedUser);
                                                    }
                                                  }),
                                              DetailIconButton(
                                                backColor: Colors.red,
                                                icon: Icons.logout,
                                                onTap: () {
                                                  Get.dialog(CustomDialog(
                                                    title: "Logout",
                                                    descripon: "logOut",
                                                    icon: Icons.logout,
                                                    onSuceed: () {
                                                      controller.auth.logout();
                                                    },
                                                  ));
                                                },
                                              ),
                                            ]
                                          : [
                                              DetailIconButton(
                                                icon: Icons.message,
                                                onTap: () {
                                                  controller.startPrivateChat();
                                                },
                                              ),
                                            ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: -60,
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: responsive.width * 0.2,
                                  backgroundImage:
                                      getUserImage(controller.user.value),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(title: Text("$index"));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
