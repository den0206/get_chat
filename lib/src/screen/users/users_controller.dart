import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/screen/network_branch.dart/network_branch.dart';
import 'package:getx_chat/src/screen/user_detail/user_detail_sceen.dart';
import 'package:getx_chat/src/service/create_recent.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';

class UsersController extends GetxController {
  final bool isPrivate;
  UsersController({required this.isPrivate});

  final RxList<FBUser> users = <FBUser>[].obs;
  final RxList<FBUser> selectedUsers = <FBUser>[].obs;

  final CreateRecentService cr = CreateRecentService();

  final int limit = 5;
  bool reachLast = false;
  DocumentSnapshot? lastDoc;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  Future<void> loadUsers() async {
    if (reachLast) {
      return;
    }

    Query ref;

    if (lastDoc == null) {
      ref = firebaseRef(FirebaseRef.user).limit(limit);
    } else {
      ref = firebaseRef(FirebaseRef.user)
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

    List<FBUser> temp = [];

    snapshots.docs.forEach(
      (doc) {
        if (doc.id != AuthController.to.current.uid) {
          temp.add(FBUser.fromMap(doc));
        }
      },
    );

    users.addAll(temp);
  }

  Future<void> createGroup() async {
    if (selectedUsers.length <= 1) {
      print("Too small...");
      return;
    } else if (selectedUsers.length >= 5) {
      print("Too many ....");
      return;
    }

    if (!NetworkManager.to.chackNetwork()) {
      return;
    }

    final group = await cr.createGroupChat(selectedUsers);

    await cr.createGroupRecent(group);
    selectedUsers.clear();

    Get.back();
  }

  void onTap(FBUser user) {
    if (isPrivate) {
      Get.to(UserDetailScreen(user: user));
    } else {
      if (!selectedUsers.contains(user)) {
        selectedUsers.add(user);
        // users.remove(user);
      } else {
        selectedUsers.remove(user);
        // users.add(user);
      }
    }
  }

  bool checkSelected(FBUser user) {
    return selectedUsers.contains(user);
  }
}
