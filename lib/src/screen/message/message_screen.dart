import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:getx_chat/src/model/message.dart';
import 'package:getx_chat/src/screen/message/message_Controller.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';

class MessageScreen extends GetView<MessageController> {
  const MessageScreen({
    Key? key,
  }) : super(key: key);
  static const routeName = '/Message';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
            child: Obx(() => ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return MessageCell(message: message);
                  },
                )),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: MessageInput(),
          )
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 16),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back, color: Colors.black),
              ),
              SizedBox(
                width: 2,
              ),
              CircleAvatar(
                backgroundImage: getUserImage(controller.withUser),
                maxRadius: 20,
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.withUser.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "Online",
                      style: TextStyle(color: Colors.grey.shade600),
                    )
                  ],
                ),
              ),
              Icon(Icons.settings, color: Colors.black54),
            ],
          ),
        ),
      ),
      title: Text(controller.withUser.name),
    );
  }
}

class MessageCell extends StatelessWidget {
  const MessageCell({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: context.width - 200,
      margin: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Card(
        color: message.isCurrent ? Colors.grey.shade600 : Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: message.isCurrent ? 10 : 0,
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  child: ClipOval(
                    child: SizedBox.expand(
                      child: Image.asset(
                        'assets/images/defaultDark.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Name",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("date")
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      message.text,
                    )
                  ],
                ))
              ],
            ),
          ),
          onLongPress: () {},
        ),
      ),
    );
  }
}

class MessageInput extends GetView<MessageController> {
  const MessageInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight,
      width: context.width,
      padding: EdgeInsets.only(left: 10, bottom: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: TextField(
              controller: controller.textControlller,
              decoration: InputDecoration(
                hintText: "Message...",
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          FloatingActionButton(
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 18,
            ),
            backgroundColor: Colors.green,
            elevation: 0,
            onPressed: () {
              if (controller.textControlller.text.isEmpty) {
                return null;
              } else {
                controller.sendMessage();
              }
            },
          )
        ],
      ),
    );
  }
}
