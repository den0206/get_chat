import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/model/recent.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/message/message_screen.dart';
import 'package:getx_chat/src/service/recent_extention.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';
import 'package:getx_chat/src/widgets/custom_dialog.dart';

class RecentsController extends GetxController {
  static RecentsController get to => Get.find();

  final recents = <Recent>[].obs;
  final searvice = RecentExtensionSearvice();

  bool reachLast = false;

  List<StreamSubscription<QuerySnapshot>> listners = [];

  @override
  void onInit() {
    super.onInit();
    recentListner();
    loadRecents();
  }

  @override
  void onClose() {
    recents.clear();
    for (final listener in listners) listener.cancel();

    print("recent Close");
    super.onClose();
  }

  Future<void> loadRecents() async {
    if (reachLast) {
      return;
    }
    try {
      final tempRecents = await searvice.loadRecents();
      if (tempRecents.length < searvice.limit) {
        reachLast = true;
      }
      recents.addAll(tempRecents);
    } catch (e) {
      showError(e);
    }
  }

  void recentListner() {
    final _subscription = searvice.addReadListner(
      (tempRecent) {
        if ((!recents.map((recent) => recent.id).contains(tempRecent.id))) {
          if (tempRecent.withUserId != null) {
            tempRecent.setWithUser((user) {
              tempRecent.withUser = user;
              recents.insert(0, tempRecent);
            });
          } else {
            tempRecent.setGroup((group) {
              tempRecent.group = group;
              recents.insert(0, tempRecent);
            });
          }
        } else {
          int index =
              recents.indexWhere((recent) => recent.id == tempRecent.id);

          final oldRecents = recents[index];
          if (oldRecents.withUser != null) {
            tempRecent.withUser = oldRecents.withUser;
          } else {
            tempRecent.group = oldRecents.group;
          }

          recents[index] = tempRecent;
          recents.sort((a, b) => b.date.compareTo(a.date));
        }
      },
    );

    listners.add(_subscription);
  }

  Future pushMessage(Recent recent) async {
    List<FBUser> argumentUser = [];
    switch (recent.type) {
      case RecentType.private:
        argumentUser.add(recent.withUser!);
        break;
      case RecentType.group:
        argumentUser.addAll(recent.group!.members);
        break;
    }

    final argumants = [recent.chatRoomId, argumentUser];
    final _ = await Get.toNamed(MessageScreen.routeName, arguments: argumants);

    resetCounter(recent);
  }

  void resetCounter(Recent tempRecent) {
    final index = recents.indexWhere((recent) => recent.id == tempRecent.id);
    final oldRecent = recents[index];

    if (oldRecent.counter != 0) {
      print("Reset Counter");
      tempRecent.counter = 0;
      recents[index] = tempRecent;

      firebaseRef(FirebaseRef.recent)
          .doc(tempRecent.id)
          .update({RecentKey.counter: tempRecent.counter});
    }
  }

  void deleteRecent(Recent recent) {
    firebaseRef(FirebaseRef.recent).doc(recent.id).delete();

    recents.remove(recent);
  }
}
