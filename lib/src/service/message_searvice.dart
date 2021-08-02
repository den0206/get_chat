import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/model/message.dart';
import 'package:getx_chat/src/model/recent.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/screen/network_branch.dart/network_branch.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';
import 'package:getx_chat/src/utils/storageSearvice.dart';
import 'package:getx_chat/src/utils/video_extension.dart';
import 'package:uuid/uuid.dart';

class MessageService {
  late final String chatRoomId;
  late final List<FBUser> withUses;
  FBUser get withUser => withUses.first;

  final currentUser = Get.find<AuthController>().current;
  final int limit = 10;

  DocumentSnapshot? lastDoc;

  MessageService({
    required this.chatRoomId,
    required this.withUses,
  });

  /// load
  Future<List<Message>> loadMessage() async {
    List<Message> temp = [];
    if (!NetworkManager.to.chackNetwork()) {
      return temp;
    }

    Query ref;
    if (lastDoc == null) {
      ref = firebaseRef(FirebaseRef.message)
          .doc(currentUser.uid)
          .collection(chatRoomId)
          .orderBy(MessageKey.date, descending: true)
          .limit(limit);
    } else {
      await Future.delayed(Duration(seconds: 2));

      ref = firebaseRef(FirebaseRef.message)
          .doc(currentUser.uid)
          .collection(chatRoomId)
          .orderBy(MessageKey.date, descending: true)
          .startAfterDocument(lastDoc!)
          .limit(limit);
    }

    final snapshots = await ref.get();

    if (snapshots.docs.isEmpty) {
      return temp;
    }

    snapshots.docs.forEach(
      (doc) {
        final Message message = Message.fromMap(doc);
        temp.add(message);
      },
    );

    lastDoc = snapshots.docs.last;

    return temp;
  }

  /// write
  Future<void> sendMessage(MessageType type, [String? text, File? file]) async {
    if (!NetworkManager.to.chackNetwork()) {
      return;
    }

    final messageId = Uuid().v4();

    final videoPath = "${currentUser.uid}/$messageId/video";
    final imagePath = "${currentUser.uid}/$messageId/image";

    String lastText;
    String? imageUrl;
    String? videoUrl;

    switch (type) {
      case MessageType.text:
        if (text == null) {
          return;
        }
        lastText = text;
        break;
      case MessageType.image:
        if (file == null) {
          return;
        }
        lastText = "image";
        imageUrl = await StorageSeavice.uploadStorage(
          ref: StorageRef.source,
          path: imagePath,
          file: file,
        );
        break;

      case MessageType.video:
        lastText = "video";
        if (file == null) {
          return;
        }
        final thubnail = await VideoExtension.getThumbnail(file);

        if (thubnail == null) {
          return;
        }

        imageUrl = await StorageSeavice.uploadStorage(
          ref: StorageRef.source,
          path: imagePath,
          file: thubnail,
        );

        videoUrl = await StorageSeavice.uploadStorage(
          ref: StorageRef.source,
          path: videoPath,
          file: file,
          type: UploadType.video,
          showValue: true,
        );
        break;
    }

    final Message message = Message(
      id: messageId,
      chatRoomId: chatRoomId,
      text: lastText,
      userId: currentUser.uid,
      date: Timestamp.now(),
      read: false,
      imageUrl: imageUrl ?? null,
      videoUrl: videoUrl ?? null,
    );

    [currentUser, withUser].forEach((user) async {
      await firebaseRef(FirebaseRef.message)
          .doc(user.uid)
          .collection(chatRoomId)
          .doc(messageId)
          .set(message.toMap());
    });

    await updateRecent(chatRoomId, message.text);
  }

  /// delete
  Future<void> deleteMessage(Message tempMessage) async {
    List<String> paths = [];

    switch (tempMessage.type) {
      case MessageType.image:
        paths = [
          tempMessage.imagePath,
        ];
        break;
      case MessageType.video:
        paths = [
          tempMessage.imagePath,
          tempMessage.videoPath,
        ];
        break;
      default:
    }

    try {
      if (paths.isNotEmpty) {
        paths.forEach(
          (path) async {
            await storageRef(StorageRef.source).child(path).delete();
          },
        );
      }

      [currentUser, withUser].forEach(
        (user) async {
          await firebaseRef(FirebaseRef.message)
              .doc(user.uid)
              .collection(chatRoomId)
              .doc(tempMessage.id)
              .delete();
        },
      );

      await updateRecent(chatRoomId, "delete", true);
    } catch (e) {
      rethrow;
    }
  }
}
