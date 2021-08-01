import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_chat/src/model/recent.dart';
import 'package:getx_chat/src/screen/message/message_screen.dart';
import 'package:getx_chat/src/screen/recent/recents_controller.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';

class RecentsScreen extends GetView<RecentsController> {
  RecentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(RecentsController());

    return Scaffold(
      backgroundColor: Colors.green[600],
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Recents'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )),
        child: Obx(
          () => ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemCount: controller.recents.length,
            itemBuilder: (BuildContext context, int index) {
              final recent = controller.recents[index];

              return RecentCell(recent: recent);
            },
          ),
        ),
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
    return Slidable(
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
      child: InkWell(
        onTap: () async {
          final argumants = [recent.chatRoomId, recent.withUser];
          final _ =
              await Get.toNamed(MessageScreen.routeName, arguments: argumants);

          controller.resetCounter(recent);
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Row(
            children: [
              Container(
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
                        backgroundImage: getUserImage(recent.withUser),
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
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    recent.withUser.name,
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
                  Text(
                    recent.lastMessage,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w500),
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
        ),
      ),
    );
  }
}
