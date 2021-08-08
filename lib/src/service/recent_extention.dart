import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/model/group.dart';
import 'package:getx_chat/src/model/recent.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/screen/network_branch.dart/network_branch.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';

class RecentExtensionSearvice {
  final int limit = 5;
  DocumentSnapshot? lastDoc;

  final currentUser = Get.find<AuthController>().current;

  Future<List<Recent>> loadRecents() async {
    List<Recent> temp = [];

    if (!NetworkManager.to.chackNetwork()) {
      return temp;
    }

    Query ref;

    if (lastDoc == null) {
      ref = firebaseRef(FirebaseRef.recent)
          .where(RecentKey.userId, isEqualTo: currentUser.uid)
          .limit(limit);
    } else {
      ref = firebaseRef(FirebaseRef.recent)
          .where(RecentKey.userId, isEqualTo: currentUser.uid)
          .startAfterDocument(lastDoc!)
          .limit(limit);
    }

    final snapshots = await ref.get();

    if (snapshots.docs.isEmpty) {
      return temp;
    }

    lastDoc = snapshots.docs.last;

    for (var doc in snapshots.docs) {
      Recent recent = Recent.fromDocument(doc);

      if (recent.type == RecentType.private) {
        var userSnapshot = await firebaseRef(FirebaseRef.user)
            .doc(doc[RecentKey.withUserId])
            .get();

        recent.withUser = FBUser.fromMap(userSnapshot);
      } else {
        var groupSnapchat =
            await firebaseRef(FirebaseRef.group).doc(recent.chatRoomId).get();

        final memberIds = List<String>.from(groupSnapchat[GroupKey.memberIds]);

        List<FBUser> member = [];

        await Future.forEach(memberIds, (String id) async {
          if (id != currentUser.uid) {
            var userSnapshot =
                await firebaseRef(FirebaseRef.user).doc(id).get();

            member.add(FBUser.fromMap(userSnapshot));
          }
        });

        // member.insert(0, currentUser);
        recent.group = Group(
          id: groupSnapchat[GroupKey.id],
          ownerId: groupSnapchat[GroupKey.ownerId],
          members: member,
        );
      }

      temp.add(recent);
    }

    temp.sort((a, b) => b.date.compareTo(a.date));
    return temp;
  }

  StreamSubscription<QuerySnapshot> addReadListner(
      Function(Recent tempRecent) onChage) {
    final _subscription = firebaseRef(FirebaseRef.recent)
        .where(RecentKey.userId, isEqualTo: currentUser.uid)
        .where(RecentKey.date, isGreaterThan: Timestamp.now())
        .snapshots(includeMetadataChanges: true)
        .listen(
      (data) {
        final List<DocumentChange> documentChange = data.docChanges;
        documentChange.forEach((recentChange) {
          if (recentChange.type == DocumentChangeType.removed) {
            return;
          }
          final tempRecent = Recent.fromDocument(recentChange.doc);
          onChage(tempRecent);
        });
      },
    );

    return _subscription;
  }
}
