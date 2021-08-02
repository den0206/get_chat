import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/utils/date_format.dart';

class Message {
  final String id;
  final String chatRoomId;
  final String text;
  final String userId;
  final Timestamp date;

  String? imageUrl;
  String? videoUrl;

  bool read;

  MessageType get type {
    if (videoUrl != null && imageUrl != null) {
      return MessageType.video;
    } else if (imageUrl != null) {
      return MessageType.image;
    }
    return MessageType.text;
  }

  String get imagePath {
    if (imageUrl != null) {
      return "$userId/$id/image";
    }
    return "";
  }

  String get videoPath {
    if (videoUrl != null) {
      return "$userId/$id/video";
    }
    return "";
  }

  String get formattedTime {
    return DateFormatter().getVerboseDateTimeRepresentation(date.toDate());
  }

  bool get isCurrent {
    return Get.find<AuthController>().currentUser?.uid == userId;
  }

  Message({
    required this.id,
    required this.chatRoomId,
    required this.text,
    required this.userId,
    required this.date,
    required this.read,
    this.imageUrl,
    this.videoUrl,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      MessageKey.id: id,
      MessageKey.chatRoomId: chatRoomId,
      MessageKey.text: text,
      MessageKey.userId: userId,
      MessageKey.date: date,
      MessageKey.read: read,
    };
    if (imageUrl != null) map[MessageKey.imageUrl] = imageUrl;
    if (videoUrl != null) map[MessageKey.videoUrl] = videoUrl;
    return map;
  }

  factory Message.fromMap(DocumentSnapshot<Object?> map) {
    return Message(
      id: map[MessageKey.id],
      chatRoomId: map[MessageKey.chatRoomId],
      text: map[MessageKey.text],
      userId: map[MessageKey.userId],
      date: map[MessageKey.date],
      read: (map.data() as Map<String, dynamic>).containsKey(MessageKey.read)
          ? map[MessageKey.read]
          : false,
      imageUrl:
          (map.data() as Map<String, dynamic>).containsKey(MessageKey.imageUrl)
              ? map[MessageKey.imageUrl]
              : null,
      videoUrl:
          (map.data() as Map<String, dynamic>).containsKey(MessageKey.videoUrl)
              ? map[MessageKey.videoUrl]
              : null,
    );
  }

  static MessageType typefromString(String value) {
    switch (value) {
      case "Text":
        return MessageType.text;
      case "Image":
        return MessageType.image;
      case "Video":
        return MessageType.video;
      default:
        return MessageType.text;
    }
  }
}

class MessageKey {
  static final id = "id";
  static final chatRoomId = "chatRoomId";
  static final text = "text";
  static final userId = "userId";
  static final date = "date";
  static final read = "read";
  static final type = "type";
  static final imageUrl = "imgeUrl";
  static final videoUrl = "videoUrl";
}

enum MessageType { text, image, video }

extension MessageTypEXT on MessageType {
  String get name {
    switch (this) {
      case MessageType.text:
        return "Text";
      case MessageType.image:
        return "Image";
      case MessageType.image:
        return "Video";
      default:
        return "";
    }
  }
}
