import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_chat/src/model/recent.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/screen/recent/recents_controller.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/user_detail/user_detail_sceen.dart';
import 'package:getx_chat/src/screen/users/users_screen.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';
import 'package:getx_chat/src/widgets/overlap_avatars.dart';

class RecentsScreen extends GetView<RecentsController> {
  RecentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(RecentsController());

    return CupertinoPageScaffold(
      backgroundColor: Colors.green,
      child: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            toolbarHeight: 70,
            elevation: 0,
            // leadingWidth: 50,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  // radius: 20,
                  backgroundImage: getUserImage(AuthController.to.current),
                ),
                onTap: () {
                  Get.to(
                    UserDetailScreen(
                      user: AuthController.to.current,
                    ),
                    fullscreenDialog: true,
                    transition: Transition.cupertinoDialog,
                  );
                },
              ),
            ),
            title: Text("Recents"),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.person_add,
                ),
                onPressed: () {
                  Get.toNamed(UsersScreen.routeName, arguments: false);
                },
              )
            ],
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              print("refresh");
            },
          ),
          SliverToBoxAdapter(
            child: Container(
              // color: Colors.green,
              height: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final recent = controller.recents[index];
                  return RecentCell(recent: recent);
                },
                childCount: controller.recents.length,
              ),
            ),
          ),
          SliverFillRemaining(
            child: Container(
              color: Colors.white,
            ),
            hasScrollBody: false,
          ),
        ],
      ),
    );
  }
}

class RecentCell extends GetView<RecentsController> {
  const RecentCell({
    Key? key,
    required this.recent,
  }) : super(key: key);

  final Recent recent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await controller.pushMessage(recent);
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Slidable(
          key: Key(recent.id),
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          secondaryActions: [
            IconSlideAction(
              caption: 'delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                controller.deleteRecent(recent);
              },
            ),
          ],
          child: Column(
            children: [
              Row(
                children: [
                  recent.type == RecentType.private
                      ? Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(.3),
                                  offset: Offset(0, 5),
                                  blurRadius: 25)
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  backgroundImage:
                                      getUserImage(recent.withUser!),
                                ),
                              ),
                              recent.counter != 0
                                  ? Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        height: 15,
                                        width: 15,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 3,
                                          ),
                                          shape: BoxShape.circle,
                                          color: Colors.green,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        )
                      : OverlapAvatars(users: recent.group!.members),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        recent.type == RecentType.private
                            ? recent.withUser!.name
                            : recent.group?.title ?? "Group",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff686795),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        constraints:
                            BoxConstraints(minWidth: 100, maxWidth: 200),
                        child: Text(
                          recent.lastMessage,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (recent.counter != 0)
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Color(0xffEE1D1D),
                          child: Text(
                            recent.counter.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        recent.formattedTime,
                        style: TextStyle(
                          color: Color(0xffAEABC9),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.grey,
                height: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
