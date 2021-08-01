import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/widgets/custom_dialog.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final authControllr = Get.find<AuthController>();

  final _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;

  String get _email => emailController.text;
  String get _password => passwordController.text;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    emailController.clear();
    passwordController.clear();
    super.onClose();
  }

  void clear() {
    emailController.clear();
    passwordController.clear();
  }

  Future<void> loginUser() async {
    isLoading.value = true;

    try {
      UserCredential _credential = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);

      if (_credential.user != null) {
        await authControllr.setCurrentUser();
        print("Success");
        onClose();
      }
    } catch (e) {
      showError(e);
    } finally {
      isLoading.value = false;
    }
  }
}
