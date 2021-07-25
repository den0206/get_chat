import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_chat/src/model/recent.dart';
import 'package:getx_chat/src/screen/message/message_screen.dart';
import 'package:getx_chat/src/screen/recent/recents_controller.dart';
import 'package:get/get.dart';

class RecentsScreen extends StatelessWidget {
  const RecentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recents'),
      ),
      body: GetX<RecentsController>(
        init: RecentsController(),
        builder: (controller) {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemCount: controller.recents.length,
            itemBuilder: (BuildContext context, int index) {
              final recent = controller.recents[index];

              return RecentCell(recent: recent);
            },
          );
        },
      ),
    );
  }
}

class RecentCell extends StatelessWidget {
  const RecentCell({
    Key? key,
    required this.recent,
  }) : super(key: key);

  final Recent recent;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: recent.withUser.imageUrl.isEmpty
            ? Image.asset("assets/images/defaultDark.png").image
            : NetworkImage(recent.withUser.imageUrl),
      ),
      title: Text(recent.withUser.name),
      trailing: Text(recent.formattedTime),
      onTap: () {
        Get.to(MessageScreen(
          chatRooId: recent.chatRoomId,
        ));
      },
    );
  }
}
