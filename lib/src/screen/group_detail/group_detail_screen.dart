import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_chat/src/screen/group_detail/group_detail_controller.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';
import 'package:getx_chat/src/widgets/custom_dialog.dart';
import 'package:getx_chat/src/widgets/detail_profile_space.dart';
import 'package:getx_chat/src/widgets/loading_widget.dart';
import 'package:getx_chat/src/widgets/overlap_avatars.dart';

class GroupDetailScreen extends GetView<GroupDetailController> {
  const GroupDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/GroupDetail';

  @override
  Widget build(BuildContext context) {
    return OverlayLoadingWidget(
      isLoading: controller.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Title'),
        ),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.zero,
                    height: Get.mediaQuery.size.height * 0.2,
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      padding:
                          EdgeInsets.only(top: Get.mediaQuery.size.width * 0.3),
                      child: Card(
                        elevation: 5,
                        color: Colors.transparent,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(
                            top: Get.mediaQuery.size.height * 0.13,
                            bottom: Get.mediaQuery.size.height * 0.03,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (controller.group.isOwner)
                                Text(
                                  "Your Owner",
                                  style: TextStyle(color: Colors.red),
                                ),
                              Text(
                                controller.group.title ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40.0,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                height: Get.mediaQuery.size.height * 0.02,
                              ),
                              Text(
                                controller.group.id,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: Get.mediaQuery.size.height * 0.03,
                              ),
                              DetailButtonSpace(
                                actions: controller.group.isOwner
                                    ? [
                                        DetailIconButton(
                                          icon: Icons.message,
                                          onTap: () async {
                                            await controller
                                                .getToMessaggScreen();
                                          },
                                        ),
                                        DetailIconButton(
                                          icon: Icons.delete,
                                          onTap: () {
                                            Get.dialog(
                                              CustomDialog(
                                                  title: "Delete",
                                                  descripon:
                                                      "delete this Group?",
                                                  onSuceed: () async {
                                                    await controller
                                                        .deleteGroupByOnwer();
                                                  },
                                                  icon: Icons.delete),
                                            );
                                          },
                                          backColor: Colors.red,
                                        ),
                                      ]
                                    : [
                                        DetailIconButton(
                                          icon: Icons.message,
                                          onTap: () {
                                            controller.getToMessaggScreen();
                                          },
                                        ),
                                      ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(
                      top: Get.mediaQuery.size.height * 0.2,
                    ),
                    child: OverlapAvatars(
                      users: controller.group.members,
                      size: Get.mediaQuery.size.width * 0.2,
                    ),
                  ),
                ],
              ),
              Divider(),
              ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(),
                itemCount: controller.group.members.length,
                itemBuilder: (context, index) {
                  final user = controller.group.members[index];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: getUserImage(user),
                    ),
                    title: Text(user.name),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
