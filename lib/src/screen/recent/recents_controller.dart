import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/model/recent.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';

class RecentsController extends GetxController {
  final AuthController auth = Get.find();

  final recents = <Recent>[].obs;
  final int limit = 5;
  bool reachLast = false;

  DocumentSnapshot? lastDoc;
  List<StreamSubscription<QuerySnapshot>> listners = [];

  static RecentsController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    recentListner();
    loadRecents();
  }

  @override
  void onClose() {
    recents.clear();
    print("Close");
    for (final listener in listners) listener.cancel();

    super.onClose();
  }

  Future<void> loadRecents() async {
    if (reachLast) {
      return;
    }

    Query ref;

    if (lastDoc == null) {
      ref = firebaseRef(FirebaseRef.recent)
          .where(RecentKey.userId, isEqualTo: auth.currentUser?.uid)
          .limit(limit);
    } else {
      ref = firebaseRef(FirebaseRef.recent)
          .where(RecentKey.userId, isEqualTo: auth.currentUser?.uid)
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
    lastDoc = snapshots.docs.last;

    List<Recent> tempRecent = [];

    for (var doc in snapshots.docs) {
      var userSnapshot = await firebaseRef(FirebaseRef.user)
          .doc(doc[RecentKey.withUserId])
          .get();
      Recent recent = Recent.fromMap(doc);
      recent.withUser = FBUser.fromMap(userSnapshot);

      tempRecent.add(recent);
    }
    tempRecent.sort((a, b) => b.date.compareTo(a.date));
    recents.addAll(tempRecent);
  }

  void recentListner() {
    final _subscription = firebaseRef(FirebaseRef.recent)
        .where(RecentKey.userId, isEqualTo: auth.currentUser?.uid)
        .where(RecentKey.date, isGreaterThan: Timestamp.now())
        .snapshots(includeMetadataChanges: true)
        .listen(
      (data) {
        final List<DocumentChange> documentChange = data.docChanges;

        documentChange.forEach(
          (recentChange) {
            final tempRecent = Recent.fromMap(recentChange.doc);

            if (!recents.map((recent) => recent.id).contains(tempRecent.id)) {
              tempRecent.onUserCallback(
                (user) {
                  tempRecent.withUser = user;
                  recents.insert(0, tempRecent);
                },
              );
            } else {
              int index =
                  recents.indexWhere((recent) => recent.id == tempRecent.id);

              final oldRecents = recents[index];
              tempRecent.withUser = oldRecents.withUser;
              recents[index] = tempRecent;
              // print("Sort");
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
      print("Update Counter");
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

  Stream<List<Recent>> toRelation() async* {
    var q = firebaseRef(FirebaseRef.recent)
        .where(RecentKey.userId, isEqualTo: auth.currentUser?.uid)
        .snapshots();

    await for (var recentSnapshot in q) {
      for (var doc in recentSnapshot.docChanges) {
        Recent recent;
        if (doc.doc[RecentKey.withUserId] != null) {
          var userSnapshot = await firebaseRef(FirebaseRef.user)
              .doc(doc.doc[RecentKey.withUserId])
              .get();
          recent = Recent.fromMap(doc.doc);
          recent.withUser = FBUser.fromMap(userSnapshot);
        } else {
          recent = Recent.fromMap(doc.doc);
        }
        recents.add(recent);
      }
    }

    yield recents;
  }
}
