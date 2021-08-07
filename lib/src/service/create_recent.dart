import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/model/group.dart';
import 'package:getx_chat/src/model/recent.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';
import 'package:uuid/uuid.dart';

class CreateRecentService {
  /// private

  Future<String> createChatRoom(
      String currentUID, String withUserID, List<FBUser> users) async {
    var chatRoomId;

    final value = currentUID.compareTo(withUserID);

    /// unique
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
        _createRecentFirestore(uid, currentUID, users, chatRoomId);
      },
    );

    print(tempMembers.length);

    return chatRoomId;
  }

  static void _createRecentFirestore(
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

  /// group
  Future<Group> createGroupChat(List<FBUser> members) async {
    final id = Uuid().v4();
    final owner = AuthController.to.current;
    members.insert(0, owner);

    final group = Group(
      id: id,
      ownerId: owner.uid,
      members: members,
    );

    group.members.forEach(
      (user) {
        firebaseRef(FirebaseRef.group).doc(group.id).set(group.toMap());
      },
    );

    return group;
  }

  Future<void> createGroupRecent(Group group,
      [List<FBUser>? tempMembers]) async {
    final member = tempMembers ?? group.members;

    await Future.forEach(member, (FBUser user) async {
      final ref = firebaseRef(FirebaseRef.recent).doc();
      final id = ref.id;

      final Map<String, dynamic> data = {
        RecentKey.id: id,
        RecentKey.userId: user.uid,
        RecentKey.chatRoomId: group.id,
        RecentKey.groupId: group.id,
        RecentKey.lastMessage: "",
        RecentKey.counter: 0,
        RecentKey.date: Timestamp.now(),
      };

      await ref.set(data);
    });
  }

  Future<void> checkExistGroupRecent(Group group) async {
    final List<FBUser> tempMembers = group.members;
    tempMembers.add(AuthController.to.current);

    List<String> tempMemberIds = tempMembers.map((user) => user.uid).toList();

    final q = await firebaseRef(FirebaseRef.recent)
        .where(RecentKey.chatRoomId, isEqualTo: group.id)
        .get();

    if (q.docs.isNotEmpty) {
      for (QueryDocumentSnapshot<Object?> recent in q.docs) {
        final currentRecent = recent;

        final String current = currentRecent[RecentKey.userId];
        if (tempMemberIds.contains(current)) {
          tempMembers.removeWhere((user) => user.uid == current);
        }
      }
    }

    print("RecCrate Recent Count is ${tempMembers.length}");
    if (tempMembers.isNotEmpty) {
      createGroupRecent(group, tempMembers);
    }
  }
}
