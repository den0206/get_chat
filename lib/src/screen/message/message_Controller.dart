import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/model/message.dart';
import 'package:getx_chat/src/model/recent.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/screen/network_branch.dart/network_branch.dart';
import 'package:getx_chat/src/screen/widgets/custom_dialog.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';
import 'package:getx_chat/src/utils/image_extension.dart';
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
  bool isloading = false;

  final RxBool showEmoji = false.obs;
  final RxBool showPanel = false.obs;

  DocumentSnapshot? lastDoc;
  List<StreamSubscription<QuerySnapshot>> streams = [];
  bool reachLast = false;

  final FocusNode fN = FocusNode();
  final TextEditingController tC = TextEditingController();
  final ScrollController sC = ScrollController();

  @override
  void onInit() {
    super.onInit();

    listenFocus();

    newChatListner();
    loadMessage();
  }

  @override
  void onClose() {
    fN.dispose();
    sC.dispose();
    for (final stream in streams) stream.cancel();
    super.onClose();
  }

  Future<void> loadMessage() async {
    if (reachLast || isloading) {
      return;
    }
    isloading = true;

    try {
      Query ref;

      if (lastDoc == null) {
        ref = firebaseRef(FirebaseRef.message)
            .doc(currentUser.uid)
            .collection(chatRoomId)
            .orderBy(MessageKey.date, descending: true)
            .limit(limit);
      } else {
        await Future.delayed(Duration(seconds: 2));
        print("More");
        ref = firebaseRef(FirebaseRef.message)
            .doc(currentUser.uid)
            .collection(chatRoomId)
            .orderBy(MessageKey.date, descending: true)
            .startAfterDocument(lastDoc!)
            .limit(limit);
      }

      final snapshots = await ref.get();

      if (snapshots.docs.length < limit) {
        reachLast = true;
      }
      if (snapshots.docs.isEmpty) {
        return;
      }

      List<Message> temp = [];

      lastDoc = snapshots.docs.last;

      snapshots.docs.forEach(
        (doc) {
          final Message message = Message.fromMap(doc);

          temp.add(message);
        },
      );

      messages.addAll(temp);

      List<String> unReadMessages = temp
          .where((message) => !message.read && message.isCurrent)
          .map((e) => e.id)
          .toList();

      messages.forEach(
        (message) {
          if (!message.isCurrent && !message.read) {
            updateReadStatus(message);
          }
        },
      );

      readListner(unReadMessages);
    } catch (e) {
      showError(e);
    } finally {
      isloading = false;
    }
  }

  Future<void> sendMessage() async {
    if (tC.text.isEmpty || !NetworkManager.to.chackNetwork()) {
      return;
    }

    final users = [currentUser, withUser];
    final messageId = Uuid().v4();
    final text = tC.text;

    final Message message = Message(
      id: messageId,
      chatRoomId: chatRoomId,
      text: text,
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
    await updateRecent(chatRoomId, text);
  }

  void _scrollToBottom() {
    sC.animateTo(
      sC.position.minScrollExtent,
      duration: 500.milliseconds,
      curve: Curves.easeIn,
    );
  }
}

extension MessageControllerExtension on MessageController {
  void setEmoji({bool hide = false}) {
    if (hide) {
      if (showEmoji.value) showEmoji.value = false;
    } else {
      showEmoji.value = !showEmoji.value;
    }
  }

  void showFileShhet() {
    Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.videocam),
              title: Text('Camera'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Gallary'),
              onTap: () async {
                final a = await ImageExtension.selectImage();
                Get.back();
                print(a);
              },
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text('Cancel'),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  /// listner

  void listenFocus() {
    return fN.addListener(() {
      showPanel.value = fN.hasFocus;
      if (fN.hasFocus) {
        if (showEmoji.value) showEmoji.value = false;
      }
    });
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

                if (!message.isCurrent && !message.read) {
                  updateReadStatus(message);
                }
              }
            }
          },
        );
      },
    );

    streams.add(_subscription);
  }

  void readListner(List<String> unreads) {
    if (unreads.isEmpty) {
      return;
    }

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

  void updateReadStatus(Message tempMessage) {
    final users = [currentUser, withUser];

    if (!tempMessage.read) {
      final data = {MessageKey.read: true};
      int indexWhere = messages.indexWhere((message) {
        return tempMessage.id == message.id;
      });

      messages[indexWhere].read = true;

      users.forEach(
        (user) {
          firebaseRef(FirebaseRef.message)
              .doc(user.uid)
              .collection(chatRoomId)
              .doc(tempMessage.id)
              .set(
                data,
                SetOptions(merge: true),
              )
              .then((value) => print("Read"));
        },
      );
    }
  }
}
