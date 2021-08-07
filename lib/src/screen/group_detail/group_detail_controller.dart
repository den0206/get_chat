import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/model/group.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/model/recent.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/screen/message/message_screen.dart';
import 'package:getx_chat/src/service/create_recent.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';
import 'package:getx_chat/src/widgets/custom_dialog.dart';

class GroupDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GroupDetailController());
  }
}

class GroupDetailController extends GetxController {
  final Group group = Get.arguments;
  final FBUser currentUser = AuthController.to.current;
  final CreateRecentService cR = CreateRecentService();

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getToMessaggScreen() async {
    await cR.checkExistGroupRecent(group);

    Get.until((route) => route.isFirst);

    final arguments = [group.id, group.members];
    Get.toNamed(MessageScreen.routeName, arguments: arguments);
  }

  Future<void> deleteGroupByOnwer() async {
    if (!group.isOwner) {
      return;
    }

    isLoading.value = true;

    try {
      /// delete Recent
      final q = await firebaseRef(FirebaseRef.recent)
          .where(RecentKey.chatRoomId, isEqualTo: group.id)
          .get();

      if (q.docs.isNotEmpty) {
        await Future.forEach(
          q.docs,
          (QueryDocumentSnapshot<Object?> doc) async {
            await doc.reference.delete();
          },
        );
      }

      /// delete group Messages
      final List<FBUser> allMembers = [];
      allMembers.addAll(group.members);
      allMembers.add(currentUser);

      await Future.forEach(
        allMembers,
        (FBUser user) async {
          final ref = await firebaseRef(FirebaseRef.message)
              .doc(user.uid)
              .collection(group.id)
              .get();

          if (ref.docs.isNotEmpty) {
            await Future.forEach(
              ref.docs,
              (QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
                await doc.reference.delete();
              },
            );
          }
        },
      );

      /// delete group doc
      await firebaseRef(FirebaseRef.group)
          .doc(group.id)
          .delete()
          .then((value) => print("Delete Group"));

      Get.until((route) => route.isFirst);
    } catch (e) {
      showError(e);
    } finally {
      isLoading.value = false;
    }
  }
}
