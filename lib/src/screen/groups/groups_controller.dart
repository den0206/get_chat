import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/model/group.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';

class GroupsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GroupsController());
  }
}

class GroupsController extends GetxController {
  final RxList<Group> groups = <Group>[].obs;
  final FBUser current = AuthController.to.current;

  final int limit = 5;
  bool reachLast = false;
  DocumentSnapshot? lastDoc;

  @override
  void onInit() {
    super.onInit();
    loadGroup();
  }

  Future<void> loadGroup() async {
    if (reachLast) {
      return;
    }
    Query ref;

    if (lastDoc == null) {
      ref = firebaseRef(FirebaseRef.group)
          .where(GroupKey.memberIds, arrayContains: current.uid)
          .limit(limit);
    } else {
      ref = firebaseRef(FirebaseRef.group)
          .where(GroupKey.memberIds, arrayContains: current.uid)
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

    List<Group> temp = [];

    await Future.forEach(snapshots.docs,
        (QueryDocumentSnapshot<Object?> doc) async {
      final memberIds = List<String>.from(doc[GroupKey.memberIds]);
      List<FBUser> member = [];

      await Future.forEach(
        memberIds,
        (String id) async {
          if (id != current.uid) {
            var userSnapshot =
                await firebaseRef(FirebaseRef.user).doc(id).get();

            member.add(FBUser.fromMap(userSnapshot));
          }
        },
      );

      final group = Group(
        id: doc[GroupKey.id],
        ownerId: doc[GroupKey.ownerId],
        members: member,
      );

      temp.add(group);
    });

    groups.addAll(temp);
  }
}
