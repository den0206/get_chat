import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_chat/src/model/recent.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
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
    final _subscription = firebaseRef(FirebaseRef.recent)
        .where(RecentKey.userId, isEqualTo: AuthController.to.current.uid)
        .where(RecentKey.date, isGreaterThan: Timestamp.now())
        .snapshots(includeMetadataChanges: true)
        .listen(
      (data) {
        final List<DocumentChange> documentChange = data.docChanges;

        documentChange.forEach(
          (recentChange) {
            final tempRecent = Recent.fromDocument(recentChange.doc);

            if (!recents.map((recent) => recent.id).contains(tempRecent.id)) {
              if (tempRecent.withUserId != null) {
                tempRecent.onUserCallback(
                  (user) {
                    tempRecent.withUser = user;
                    recents.insert(0, tempRecent);
                  },
                );
              }
            } else {
              int index =
                  recents.indexWhere((recent) => recent.id == tempRecent.id);

              final oldRecents = recents[index];
              if (oldRecents.withUser != null) {
                tempRecent.withUser = oldRecents.withUser;
              }

              recents[index] = tempRecent;
              recents.sort((a, b) => b.date.compareTo(a.date));
            }
          },
        );
      },
    );

    listners.add(_subscription);
  }

  void resetCounter(Recent tempRecent) {
    final index = recents.indexWhere((recent) => recent.id == tempRecent.id);
    final oldRecent = recents[index];

    if (oldRecent.counter != 0) {
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



  // Stream<List<Recent>> toRelation() async* {
  //   var q = firebaseRef(FirebaseRef.recent)
  //       .where(RecentKey.userId, isEqualTo: searvice.currentUser)
  //       .snapshots();

  //   await for (var recentSnapshot in q) {
  //     for (var doc in recentSnapshot.docChanges) {
  //       Recent recent;
  //       if (doc.doc[RecentKey.withUserId] != null) {
  //         var userSnapshot = await firebaseRef(FirebaseRef.user)
  //             .doc(doc.doc[RecentKey.withUserId])
  //             .get();
  //         recent = Recent.fromDocument(doc.doc);
  //         recent.withUser = FBUser.fromMap(userSnapshot);
  //       } else {
  //         recent = Recent.fromDocument(doc.doc);
  //       }
  //       recents.add(recent);
  //     }
  //   }

  //   yield recents;
  // }