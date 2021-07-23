import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';

class AuthController extends GetxService {
  Rxn<User> user = Rxn<User>();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    user.bindStream(auth.authStateChanges());
    user.bindStream(auth.userChanges());

    super.onInit();
  }
}
