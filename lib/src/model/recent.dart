import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/model/group.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/utils/date_format.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';

enum RecentType { private, group }

class Recent {
  final String id;
  final String userId;
  final String chatRoomId;
  final String lastMessage;
  int counter;
  final Timestamp date;

  final String? withUserId;
  FBUser? withUser;

  Group? group;

  String get formattedTime {
    return DateFormatter().getVerboseDateTimeRepresentation(date.toDate());
  }

  RecentType get type {
    if (withUserId != null) {
      return RecentType.private;
    }
    return RecentType.group;
  }

  Recent({
    required this.id,
    required this.userId,
    required this.chatRoomId,
    required this.lastMessage,
    required this.counter,
    required this.date,
    this.withUserId,
  });

  factory Recent.fromDocument(DocumentSnapshot map) {
    return Recent(
      id: map[RecentKey.id],
      userId: map[RecentKey.userId],
      chatRoomId: map[RecentKey.chatRoomId],
      lastMessage: map[RecentKey.lastMessage],
      counter: map[RecentKey.counter],
      date: map[RecentKey.date],
      withUserId:
          (map.data() as Map<String, dynamic>).containsKey(RecentKey.withUserId)
              ? map[RecentKey.withUserId]
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      RecentKey.id: id,
      RecentKey.userId: userId,
      RecentKey.chatRoomId: chatRoomId,
      RecentKey.lastMessage: lastMessage,
      RecentKey.counter: counter,
      RecentKey.date: date,
    };

    if (withUserId != null) {
      map[RecentKey.withUserId] = withUserId;
    }

    return map;
  }

  Future<void> setWithUser(Function(FBUser user) onScucess) async {
    final doc = await firebaseRef(FirebaseRef.user).doc(this.withUserId).get();

    final user = FBUser.fromMap(doc);

    onScucess(user);
  }

  /// create get group func
  Future<void> setGroup(Function(Group group) onScucess) async {
    final doc = await firebaseRef(FirebaseRef.group).doc(chatRoomId).get();
    final memberIds = List<String>.from(doc[GroupKey.memberIds]);

    List<FBUser> member = [];

    await Future.forEach(
      memberIds,
      (String id) async {
        if (id != AuthController.to.current.uid) {
          var userSnapshot = await firebaseRef(FirebaseRef.user).doc(id).get();

          member.add(FBUser.fromMap(userSnapshot));
        }
      },
    );

    final group = Group(
      id: doc[GroupKey.id],
      ownerId: doc[GroupKey.ownerId],
      members: member,
    );

    onScucess(group);
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

  static final groupId = "groupId";
}

// Future<String> createChatRoom(
//     String currentUID, String withUserID, List<FBUser> users) async {
//   var chatRoomId;

//   final value = currentUID.compareTo(withUserID);

//   if (value < 0) {
//     chatRoomId = currentUID + withUserID;
//   } else {
//     chatRoomId = withUserID + currentUID;
//   }

//   final userIds = [currentUID, withUserID];
//   var tempMembers = userIds;

//   final q = await firebaseRef(FirebaseRef.recent)
//       .where(RecentKey.chatRoomId, isEqualTo: chatRoomId)
//       .get();

//   if (q.docs.isNotEmpty) {
//     for (QueryDocumentSnapshot<Object?> recent in q.docs) {
//       final currentRecent = recent;

//       final String current = currentRecent[RecentKey.userId];
//       if (userIds.contains(current)) {
//         tempMembers.remove(current);
//       }
//     }
//   }

//   tempMembers.forEach(
//     (uid) {
//       createRecentFirestore(uid, currentUID, users, chatRoomId);
//     },
//   );

//   return chatRoomId;
// }

// void createRecentFirestore(
//     String uid, String currentUID, List<FBUser> users, String chatRoomId) {
//   final ref = firebaseRef(FirebaseRef.recent).doc();
//   final id = ref.id;

//   final withUser = uid == currentUID ? users.last : users.first;

//   final Map<String, dynamic> data = {
//     RecentKey.id: id,
//     RecentKey.userId: uid,
//     RecentKey.withUserId: withUser.uid,
//     RecentKey.chatRoomId: chatRoomId,
//     RecentKey.lastMessage: "",
//     RecentKey.counter: 0,
//     RecentKey.date: Timestamp.now(),
//   };

//   ref.set(data);
// }

/// group

// Future<Group> createGroupChat(List<FBUser> members) async {
//   final id = Uuid().v4();
//   final owner = AuthController.to.current;
//   members.insert(0, owner);

//   final group = Group(
//     id: id,
//     ownerId: owner.uid,
//     members: members,
//   );

//   group.members.forEach(
//     (user) {
//       firebaseRef(FirebaseRef.group).doc(group.id).set(group.toMap());
//     },
//   );

//   return group;
// }

// void createGroupRecent(Group group) {
//   group.members.forEach(
//     (user) {
//       final ref = firebaseRef(FirebaseRef.recent).doc();
//       final id = ref.id;

//       final Map<String, dynamic> data = {
//         RecentKey.id: id,
//         RecentKey.userId: user.uid,
//         RecentKey.chatRoomId: group.id,
//         RecentKey.groupId: group.id,
//         RecentKey.lastMessage: "",
//         RecentKey.counter: 0,
//         RecentKey.date: Timestamp.now(),
//       };

//       ref.set(data);
//     },
//   );
// }

// Future<void> updateRecent(String chatRoomId, String lastMessage,
//     [bool isDelete = false]) async {
//   final q = await firebaseRef(FirebaseRef.recent)
//       .where(RecentKey.chatRoomId, isEqualTo: chatRoomId)
//       .get();

//   if (q.docs.isNotEmpty)
//     q.docs.forEach(
//       (doc) {
//         final recent = Recent.fromDocument(doc);
//         updateRecentToFirestore(recent, lastMessage, isDelete);
//       },
//     );
// }

// void updateRecentToFirestore(Recent recent, String lastMessage, bool isDelete) {
//   final date = Timestamp.now();
//   final uid = recent.userId;
//   final currentUid = Get.find<AuthController>().current.uid;
//   var counter = recent.counter;

//   if (currentUid != uid) {
//     if (!isDelete) {
//       ++counter;
//     } else {
//       --counter;
//       if (counter < 0) {
//         counter = 0;
//       }
//     }
//   }

//   final value = {
//     RecentKey.lastMessage: lastMessage,
//     RecentKey.counter: counter,
//     RecentKey.date: date
//   };

//   firebaseRef(FirebaseRef.recent).doc(recent.id).update(value);
// }
