import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';

class UsersController extends GetxController {
  final users = <FBUser>[].obs;

  @override
  void onInit() {
    super.onInit();
    users.bindStream(toDoStream());
  }

  Stream<List<FBUser>> toDoStream() {
    return firebaseRef(FirebaseRef.user).snapshots().map(
      (query) {
        return query.docs.map((doc) => FBUser.fromMap(doc)).toList();
      },
    );
  }
}

// query.docs.forEach(
//   (doc) {
//     array.add(FBUser.fromMap(doc));
//   },
// );
