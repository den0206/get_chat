import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/model/message.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';
import 'package:uuid/uuid.dart';

class MessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MessageController());
  }
}

class MessageController extends GetxController {
  final String chatRoomId = Get.arguments[0];
  final FBUser withUser = Get.arguments[1];
  final currentUser = Get.find<AuthController>().current;

  final messages = <Message>[].obs;
  final TextEditingController textControlller = TextEditingController();

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    messages.bindStream(toDoStream());

    // scrollController.jumpTo(0);
  }

  Stream<List<Message>> toDoStream() {
    return firebaseRef(FirebaseRef.message)
        .doc(currentUser.uid)
        .collection(chatRoomId)
        .orderBy(MessageKey.date, descending: false)
        .snapshots()
        .map(
      (q) {
        final List<Message> array = [];

        q.docs.forEach((doc) {
          final Message message = Message.fromMap(doc);
          array.add(message);
        });

        return array;
      },
    );
  }

  Future<void> sendMessage() async {
    if (textControlller.text.isEmpty) {
      return;
    }

    FocusScope.of(Get.context!).unfocus();
    final users = [currentUser, withUser];
    final messageId = Uuid().v4();

    final Message message = Message(
      id: messageId,
      chatRoomId: chatRoomId,
      text: textControlller.text,
      userId: currentUser.uid,
      date: Timestamp.now(),
    );

    users.forEach(
      (user) async {
        await firebaseRef(FirebaseRef.message)
            .doc(user.uid)
            .collection(chatRoomId)
            .doc(messageId)
            .set(message.toMap());
      },
    );

    textControlller.clear();

    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: 500.milliseconds,
      curve: Curves.easeIn,
    );
  }
}
