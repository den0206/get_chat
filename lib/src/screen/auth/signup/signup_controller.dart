import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';

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

  String get _fullname => nameTextControlller.text;
  String get _email => emailController.text;
  String get _password => passwordController.text;

  RxBool isLoading = false.obs;

  Future<void> register() async {
    isLoading.value = true;

    await Future.delayed(Duration(seconds: 2));

    isLoading.value = false;
  }
}
