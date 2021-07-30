import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/utils/date_format.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';
import 'package:get/get.dart';

class Recent {
  final String id;
  final String userId;
  final String withUserId;
  final String chatRoomId;
  final String lastMessage;
  final int counter;

  final Timestamp date;

  late FBUser withUser;

  String get formattedTime {
    return DateFormatter().getVerboseDateTimeRepresentation(date.toDate());
  }

  Recent({
    required this.id,
    required this.userId,
    required this.withUserId,
    required this.chatRoomId,
    required this.lastMessage,
    required this.counter,
    required this.date,
  });

  factory Recent.fromMap(DocumentSnapshot map) {
    final rec = Recent(
      id: map[RecentKey.id],
      userId: map[RecentKey.userId],
      withUserId: map[RecentKey.withUserId],
      chatRoomId: map[RecentKey.chatRoomId],
      lastMessage: map[RecentKey.lastMessage],
      counter: map[RecentKey.counter],
      date: map[RecentKey.date],
    );

    // firebaseRef(FirebaseRef.user).doc(map[RecentKey.withUserId]).get().then(
    //   (doc) {
    //     final user = FBUser.fromMap(doc);
    //     rec.withUser = user;
    //     print(rec.withUser);
    //     return rec;
    //   },
    // );

    return rec;
  }

  Map<String, dynamic> toMap() {
    return {
      RecentKey.id: id,
      RecentKey.userId: userId,
      RecentKey.withUserId: withUserId,
      RecentKey.chatRoomId: chatRoomId,
      RecentKey.lastMessage: lastMessage,
      RecentKey.counter: counter,
      RecentKey.date: date,
    };
  }
}

class RecentKey {
  static final id = "id";
  static final userId = "userId";
  static final withUserId = "withUserId";
  static final chatRoomId = "chatRoomId";
  static final lastMessage = "lastMessage";
  static final counter = "counter";
  static final date = "date";
}

Future<String> createChatRoom(
    String currentUID, String withUserID, List<FBUser> users) async {
  var chatRoomId;

  final value = currentUID.compareTo(withUserID);

  if (value < 0) {
    chatRoomId = currentUID + withUserID;
  } else {
    chatRoomId = withUserID + currentUID;
  }

  final userIds = [currentUID, withUserID];
  var tempMembers = userIds;

  final q = await firebaseRef(FirebaseRef.recent)
      .where(RecentKey.chatRoomId, isEqualTo: chatRoomId)
      .get();

  if (q.docs.isNotEmpty) {
    for (QueryDocumentSnapshot<Object?> recent in q.docs) {
      final currentRecent = recent;

      final String current = currentRecent[RecentKey.userId];
      if (userIds.contains(current)) {
        tempMembers.remove(current);
      }
    }
  }

  tempMembers.forEach(
    (uid) {
      createRecentFirestore(uid, currentUID, users, chatRoomId);
    },
  );

  return chatRoomId;
}

void createRecentFirestore(
    String uid, String currentUID, List<FBUser> users, String chatRoomId) {
  final ref = firebaseRef(FirebaseRef.recent).doc();
  final id = ref.id;

  final withUser = uid == currentUID ? users.last : users.first;

  final Map<String, dynamic> data = {
    RecentKey.id: id,
    RecentKey.userId: uid,
    RecentKey.withUserId: withUser.uid,
    RecentKey.chatRoomId: chatRoomId,
    RecentKey.lastMessage: "",
    RecentKey.counter: 0,
    RecentKey.date: Timestamp.now(),
  };

  ref.set(data);
}

Future<void> updateRecent(String chatRoomId, String lastMessage) async {
  final q = await firebaseRef(FirebaseRef.recent)
      .where(RecentKey.chatRoomId, isEqualTo: chatRoomId)
      .get();

  if (q.docs.isNotEmpty)
    q.docs.forEach(
      (doc) {
        final recent = Recent.fromMap(doc);
        updateRecentToFirestore(recent, lastMessage);
      },
    );
}

void updateRecentToFirestore(Recent recent, String lastMessage) {
  final date = Timestamp.now();
  final uid = recent.userId;
  final currentUid = Get.find<AuthController>().current.uid;
  var counter = recent.counter;

  if (currentUid != uid) {
    counter += 1;
  }

  final value = {
    RecentKey.lastMessage: lastMessage,
    RecentKey.counter: counter,
    RecentKey.date: date
  };

  firebaseRef(FirebaseRef.recent).doc(recent.id).update(value);
}
