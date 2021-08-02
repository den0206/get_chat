import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/model/message.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/screen/message/message_file_sheet.dart';
import 'package:getx_chat/src/service/message_searvice.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';
import 'package:getx_chat/src/utils/image_extension.dart';
import 'package:getx_chat/src/utils/video_extension.dart';
import 'package:getx_chat/src/widgets/custom_dialog.dart';

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

  final messages = <Message>[].obs;

  late MessageService searvice;
  bool isloading = false;
  bool reachLast = false;

  final RxBool showEmoji = false.obs;
  final RxBool showPanel = false.obs;

  List<StreamSubscription<QuerySnapshot>> listners = [];

  final FocusNode fN = FocusNode();
  final TextEditingController tC = TextEditingController();
  final ScrollController sC = ScrollController();

  @override
  void onInit() {
    super.onInit();
    searvice = MessageService(chatRoomId: chatRoomId, withUses: [withUser]);

    listenFocus();
    newChatListner();
    loadMessage();
  }

  @override
  void onClose() {
    fN.dispose();
    sC.dispose();
    for (final stream in listners) stream.cancel();
    super.onClose();
  }

  Future<void> loadMessage() async {
    if (reachLast) {
      return;
    }

    isloading = true;

    try {
      final tempMessage = await searvice.loadMessage();

      if (tempMessage.length < searvice.limit) {
        reachLast = true;
      }

      messages.addAll(tempMessage);

      List<String> unReadMessages = tempMessage
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

  Future<void> sendMessage(MessageType type, [File? file]) async {
    await searvice.sendMessage(type, tC.text, file);
    tC.clear();
    _scrollToBottom();
  }

  Future<void> deleteMessage(Message tempMessage) async {
    try {
      await searvice.deleteMessage(tempMessage);
      messages.remove(tempMessage);
      Get.back();
    } catch (e) {
      showError(e);
    }
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

  void showBottomSheet() {
    final List<MessageFileButton> actions = [
      MessageFileButton(
        icon: Icons.camera,
        onPress: () {
          print("Camera");
        },
      ),
      MessageFileButton(
        icon: Icons.image,
        onPress: () async {
          final selectedImage = await ImageExtension.selectImage();
          if (selectedImage != null) {
            Get.back();
            sendMessage(MessageType.image, selectedImage);
          }
        },
      ),
      MessageFileButton(
        icon: Icons.videocam,
        onPress: () async {
          final selectedVideo = await VideoExtension.getGarallyVideo();

          if (selectedVideo != null) {
            Get.back();
            sendMessage(MessageType.video, selectedVideo);
          }
        },
      ),
      MessageFileButton(
        icon: Icons.close,
        onPress: () {
          Get.back();
        },
      ),
    ];

    Get.bottomSheet(
      MessageFileSheet(actions: actions),
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

    listners.add(_subscription);
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

    listners.add(_subscription);
    print(listners.length);
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
