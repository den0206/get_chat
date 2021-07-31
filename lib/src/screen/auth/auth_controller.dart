import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/screen/recent/recents_controller.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';

class AuthController extends GetxService {
  Rxn<User> user = Rxn<User>();
  FirebaseAuth auth = FirebaseAuth.instance;

  static AuthController get to => Get.find();

  FBUser? currentUser;
  FBUser get current => currentUser!;

  @override
  void onInit() async {
    user.bindStream(auth.authStateChanges());
    user.bindStream(auth.userChanges());
    ever(user, (value) => print(value));

    await setCurrentUser();

    super.onInit();
  }

  Future<void> setCurrentUser({String? uid}) async {
    if (auth.currentUser == null) {
      print("No Auth");
      return;
    }

    final userId = uid ?? auth.currentUser?.uid;

    if (userId != null) {
      final doc = await firebaseRef(FirebaseRef.user).doc(userId).get();

      currentUser = FBUser.fromMap(doc);
    } else {
      print("No ID");
    }
  }

  Future<void> logout() async {
    try {
      user.value = null;
      currentUser = null;
      await Get.delete<RecentsController>();
      print(currentUser);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
