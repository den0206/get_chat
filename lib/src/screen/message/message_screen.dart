import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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
      backgroundColor: Colors.green[600],
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          controller.setEmoji(hide: true);
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Obx(() => ListView.builder(
                      physics: BouncingScrollPhysics(),
                      reverse: true,
                      controller: controller.sC,
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        final message = controller.messages[index];

                        if (index == controller.messages.length - 1) {
                          controller.loadMessage();
                          if (controller.isloading)
                            return Center(child: Text("Loading..."));
                        }
                        return MessageCell(message: message);
                      },
                    )),
              ),
            ),
            MessageInput(),
            _emojiSpace()
          ],
        ),
      ),
    );
  }

  Obx _emojiSpace() {
    return Obx(
      () => Offstage(
        offstage: !controller.showEmoji.value,
        child: SizedBox(
          height: 250,
          child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                controller.tC
                  ..text += emoji.emoji
                  ..selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.tC.text.length));
              },
              onBackspacePressed: () {
                controller.tC
                  ..text = controller.tC.text.characters.skipLast(1).toString()
                  ..selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.tC.text.length));
              },
              config: Config(
                  columns: 7,
                  emojiSizeMax: 32.0,
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  initCategory: Category.RECENT,
                  bgColor: Color(0xFFF2F2F2),
                  indicatorColor: Colors.blue,
                  iconColor: Colors.grey,
                  iconColorSelected: Colors.blue,
                  progressIndicatorColor: Colors.blue,
                  backspaceColor: Colors.blue,
                  showRecentsTab: true,
                  recentsLimit: 28,
                  noRecentsText: 'No Recents',
                  noRecentsStyle:
                      TextStyle(fontSize: 20, color: Colors.black26),
                  categoryIcons: CategoryIcons(),
                  buttonMode: ButtonMode.MATERIAL)),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      toolbarHeight: 100,
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: getUserImage(controller.withUser),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.withUser.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                "Online",
                style: TextStyle(
                    color: Color(0xffAEABC9),
                    fontSize: 14,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w500),
              ),
            ],
          )
        ],
      ),
      actions: [
        Icon(
          Icons.settings,
          color: Colors.black54,
          size: 28,
        ),
      ],
    );
  }
}

class MessageCell extends GetView<MessageController> {
  const MessageCell({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: message.isCurrent
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!message.isCurrent)
                CircleAvatar(
                  radius: 15,
                  backgroundImage: getUserImage(controller.withUser),
                ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onLongPress: () {},
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                  ),
                  decoration: BoxDecoration(
                    color: message.isCurrent ? Colors.green : Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(message.isCurrent ? 12 : 0),
                      bottomRight: Radius.circular(message.isCurrent ? 0 : 12),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                        fontSize: 24,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                        color: message.isCurrent
                            ? Colors.white
                            : Colors.grey[800]),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: message.isCurrent
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                if (message.isCurrent)
                  SizedBox(
                    width: 40,
                  ),
                if (message.read)
                  Icon(
                    Icons.done_all,
                    size: 20,
                    color: Color(0xffAEABC9),
                  ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  message.formattedTime,
                  style: TextStyle(
                    color: Color(0xffAEABC9),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MessageInput extends GetView<MessageController> {
  const MessageInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Container(
        // height: kBottomNavigationBarHeight,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14),
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.emoji_emotions_outlined),
                      color: Colors.grey[500],
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        controller.setEmoji();
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: controller.fN,
                        controller: controller.tC,
                        decoration: InputDecoration(
                          hintText: "Message...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(Icons.attach_file, color: Colors.grey[500])
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 16,
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
                if (controller.tC.text.isEmpty) {
                  return null;
                } else {
                  controller.sendMessage();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
