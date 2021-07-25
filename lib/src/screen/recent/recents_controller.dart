import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_chat/src/model/recent.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';

class RecentsController extends GetxController {
  final AuthController auth = Get.find();
  final recents = <Recent>[].obs;

  @override
  void onInit() {
    super.onInit();
    recents.bindStream(toDoStream());
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
}
