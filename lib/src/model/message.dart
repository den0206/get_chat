import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';

class Message {
  final String id;
  final String chatRoomId;
  final String text;
  final String userId;
  final Timestamp date;

  bool get isCurrent  {
    return Get.find<AuthController>().currentUser?.uid == userId;
  }

  Message({
    required this.id,
    required this.chatRoomId,
    required this.text,
    required this.userId,
    required this.date,
  });
}
