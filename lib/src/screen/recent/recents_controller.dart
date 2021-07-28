import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/model/recent.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';

class RecentsController extends GetxController {
  final AuthController auth = Get.find();
  final recents = <Recent>[].obs;

  static RecentsController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    recents.clear();
    // recents.close();
    print("DELETE");
    super.onClose();
  }

  void loadRecents() {
    if (recents.isEmpty) recents.bindStream(toRelation());
  }

  Stream<List<Recent>> toDoStream() {
    return firebaseRef(FirebaseRef.recent)
        .where(RecentKey.userId, isEqualTo: auth.currentUser?.uid)
        .snapshots()
        .map((q) {
      final List<Recent> array = [];

      q.docs.forEach((doc) {
        array.add(Recent.fromMap(doc));
      });
      return array;
    });
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
