import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

import 'package:getx_chat/src/screen/auth/auth_controller.dart';

class Message {
  final String id;
  final String chatRoomId;
  final String text;
  final String userId;
  final Timestamp date;

  final read = false.obs;

  bool get isCurrent {
    return Get.find<AuthController>().currentUser?.uid == userId;
  }

  Message({
    required this.id,
    required this.chatRoomId,
    required this.text,
    required this.userId,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      MessageKey.id: id,
      MessageKey.chatRoomId: chatRoomId,
      MessageKey.text: text,
      MessageKey.userId: userId,
      MessageKey.date: date
    };
  }

  factory Message.fromMap(DocumentSnapshot<Object?> map) {
    return Message(
        id: map[MessageKey.id],
        chatRoomId: map[MessageKey.chatRoomId],
        text: map[MessageKey.text],
        userId: map[MessageKey.userId],
        date: map[MessageKey.date]);
  }
}

class MessageKey {
  static final id = "id";
  static final chatRoomId = "chatRoomId";
  static final text = "text";
  static final userId = "userId";
  static final date = "date";
  static final read = "read";
}
