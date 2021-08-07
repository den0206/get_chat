import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_chat/src/model/group.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/model/recent.dart';
import 'package:getx_chat/src/screen/message/message_screen.dart';
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

  @override
  void onInit() {
    super.onInit();
    print(group.id);
  }

  void goMessaggScreen() {
    Get.until((route) => route.isFirst);

    final arguments = [group.id, group.members];
    Get.toNamed(MessageScreen.routeName, arguments: arguments);
  }

  Future<void> deleteGroupOnOnwer() async {
    if (!group.isOwner) {
      return;
    }

    try {
      /// delete Recent
      final q = await firebaseRef(FirebaseRef.recent)
          .where(RecentKey.chatRoomId, isEqualTo: group.id)
          .get();

      if (q.docs.isNotEmpty) {
        List<String> recentIds = [];
        await Future.forEach(
          q.docs,
          (QueryDocumentSnapshot<Object?> doc) async {
            final String recentId = doc[RecentKey.id];
            recentIds.add(recentId);
          },
        );

        await Future.forEach(recentIds, (String id) async {
          await firebaseRef(FirebaseRef.recent).doc(id).delete();
        });
      }

      /// delete group Message

      /// delete Group doc
      await firebaseRef(FirebaseRef.group)
          .doc(group.id)
          .delete()
          .then((value) => print("Delete Group"));

      Get.until((route) => route.isFirst);
    } catch (e) {
      showError(e);
    }
  }
}
