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
