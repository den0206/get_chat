import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SignUpController());
  }
}

class SignUpController extends GetxController {
  TextEditingController nameTextControlller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  String get _name => nameTextControlller.text;
  String get _email => emailController.text;
  String get _password => passwordController.text;

  RxBool isLoading = false.obs;

  Future<void> register() async {
    isLoading.value = true;

    try {
      UserCredential _credentiol = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);

      if (_credentiol.user != null) {
        final _uid = _credentiol.user!.uid;
        FBUser user = FBUser(
          uid: _uid,
          name: _name,
          email: _email,
        );
        await firebaseRef(FirebaseRef.user).doc(_uid).set(user.toMap());

        print("Success");
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
