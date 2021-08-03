import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';
import 'package:getx_chat/src/utils/image_extension.dart';
import 'package:getx_chat/src/utils/storageSearvice.dart';
import 'package:getx_chat/src/widgets/custom_dialog.dart';

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

  Rxn<File> userImage = Rxn<File>();

  final authControllr = Get.find<AuthController>();

  final _auth = FirebaseAuth.instance;

  String get _name => nameTextControlller.text;
  String get _email => emailController.text;
  String get _password => passwordController.text;

  RxBool isLoading = false.obs;

  Future<void> register() async {
    if (userImage.value == null) {
      Exception error = Exception("No Image");
      showError(error);
      return;
    }

    isLoading.value = true;

    try {
      UserCredential _credentiol = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);

      if (_credentiol.user != null) {
        final _uid = _credentiol.user!.uid;

        String _imageUrl = await StorageSeavice.uploadStorage(
            ref: StorageRef.profile, path: "$_uid", file: userImage.value!);

        print(_imageUrl);

        FBUser user = FBUser(
          uid: _uid,
          name: _name,
          email: _email,
          imageUrl: _imageUrl,
        );
        authControllr.currentUser = user;
        await firebaseRef(FirebaseRef.user).doc(_uid).set(user.toMap());
        Get.back(canPop: true);

        print("Success");
      }
    } catch (e) {
      showError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectImage() async {
    final file = await ImageExtension.selectImage();
    userImage.value = file;
  }
}
