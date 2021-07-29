import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/model/message.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/screen/widgets/custom_dialog.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';
import 'package:uuid/uuid.dart';

class MessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MessageController());
  }
}

class MessageController extends GetxController {
  /// arg
  final String chatRoomId = Get.arguments[0];
  final FBUser withUser = Get.arguments[1];

  final currentUser = Get.find<AuthController>().current;
  final int limit = 10;

  final messages = <Message>[].obs;
  final RxBool isloading = false.obs;

  DocumentSnapshot? lastDoc;
  List<StreamSubscription<QuerySnapshot>> streams = [];
  bool reachLast = false;

  final TextEditingController tC = TextEditingController();
  final ScrollController sC = ScrollController();

  @override
  void onInit() {
    super.onInit();

    newChatListner();
    loadMessage();
  }

  @override
  void onClose() {
    sC.dispose();
    for (final stream in streams) stream.cancel();
    super.onClose();
  }

  Future<void> loadMessage() async {
    if (reachLast) {
      return;
    }

    isloading.value = true;

    try {
      Query ref;

      if (lastDoc == null) {
        ref = firebaseRef(FirebaseRef.message)
            .doc(currentUser.uid)
            .collection(chatRoomId)
            .orderBy(MessageKey.date, descending: false)
            .limit(limit);
      } else {
        ref = firebaseRef(FirebaseRef.message)
            .doc(currentUser.uid)
            .collection(chatRoomId)
            .orderBy(MessageKey.date, descending: false)
            .startAfterDocument(lastDoc!)
            .limit(limit);
      }

      final snapshots = await ref.get();

      if (snapshots.docs.length > limit) {
        reachLast = true;
      }
      if (snapshots.docs.isEmpty) {
        return;
      }
      List<Message> temp = [];

      lastDoc = snapshots.docs.last;
      print(lastDoc);

      snapshots.docs.forEach(
        (doc) {
          final Message message = Message.fromMap(doc);

          temp.add(message);
        },
      );

      messages.addAll(temp);

      List<String> unReadMessages = temp
          .where((message) => message.read == false && message.isCurrent)
          .map((e) => e.id)
          .toList();

      readListner(unReadMessages);
    } catch (e) {
      print(showError(e));
    } finally {
      isloading.value = false;
    }
  }

  Future<void> sendMessage() async {
    if (tC.text.isEmpty) {
      return;
    }

    FocusScope.of(Get.context!).unfocus();
    final users = [currentUser, withUser];
    final messageId = Uuid().v4();

    final Message message = Message(
      id: messageId,
      chatRoomId: chatRoomId,
      text: tC.text,
      userId: currentUser.uid,
      date: Timestamp.now(),
      read: false,
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

    tC.clear();

    _scrollToBottom();
  }

  void _scrollToBottom() {
    sC.animateTo(
      sC.position.minScrollExtent,
      duration: 500.milliseconds,
      curve: Curves.easeIn,
    );
  }

  void newChatListner() {
    final _subscription = firebaseRef(FirebaseRef.message)
        .doc(currentUser.uid)
        .collection(chatRoomId)
        .where(MessageKey.date, isGreaterThan: Timestamp.now())
        .snapshots()
        .listen(
      (data) {
        final List<DocumentChange> documentChanges = data.docChanges;
        documentChanges.forEach(
          (messageChange) {
            final message = Message.fromMap(messageChange.doc);
            if (messageChange.type == DocumentChangeType.added) {
              if (!messages.contains(message)) {
                print("add");
                messages.insert(0, message);
              }
            }
          },
        );
      },
    );

    streams.add(_subscription);
  }

  void readListner(List<String> unreads) {
    final _subscription = firebaseRef(FirebaseRef.message)
        .doc(currentUser.uid)
        .collection(chatRoomId)
        .where(MessageKey.id, whereIn: unreads)
        .snapshots()
        .listen(
      (data) {
        final List<DocumentChange> documentChanges = data.docChanges;
        documentChanges.forEach((messageChange) {
          if (messageChange.type == DocumentChangeType.modified) {
            int indexWhere = messages.indexWhere((message) {
              return messageChange.doc.id == message.id;
            });

            if (indexWhere >= 0) {
              messages[indexWhere] = Message.fromMap(messageChange.doc);
            }
          }
        });
      },
    );

    streams.add(_subscription);
    print(streams.length);
  }
}

// Stream<List<Message>> toDoStream() {
//   return firebaseRef(FirebaseRef.message)
//       .doc(currentUser.uid)
//       .collection(chatRoomId)
//       .orderBy(MessageKey.date, descending: false)
//       .limit(limit)
//       .snapshots()
//       .map(
//     (q) {
//       return q.docs.map((doc) {
//         return Message.fromMap(doc);
//       }).toList();
//     },
//   );
// }

// if (messageChange.type == DocumentChangeType.removed) {
//   messages.removeWhere((message) {
//     return messageChange.doc.id == message.id;
//   });
//   isChange = true;
// }
