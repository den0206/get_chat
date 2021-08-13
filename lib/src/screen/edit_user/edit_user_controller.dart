import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/screen/common/main_tab_controller.dart';
import 'package:getx_chat/src/screen/user_detail/user_detail_sceen.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';
import 'package:getx_chat/src/utils/image_extension.dart';
import 'package:getx_chat/src/utils/storageSearvice.dart';
import 'package:getx_chat/src/widgets/custom_dialog.dart';

class EditUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditUserCotroller());
  }
}

class EditUserCotroller extends GetxController {
  final FBUser currentUser = AuthController.to.current;
  late final FBUser editUser;

  TextEditingController nameTextControlller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Rxn<File> userImage = Rxn<File>();
  RxBool isLoading = false.obs;
  RxBool isChanged = false.obs;
  RxBool emailChange = false.obs;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() {
    editUser = currentUser.copyWith();
    nameTextControlller.text = editUser.name;
    emailController.text = editUser.email;
  }

  Future<void> selectImage() async {
    final file = await ImageExtension.selectImage();
    userImage.value = file;
    checkChanged();
  }

  void checkChanged() {
    if (currentUser.email != editUser.email) {
      emailChange.value = true;
    } else {
      emailChange.value = false;
      passwordController.clear();
    }
    if (currentUser.name != editUser.name ||
        currentUser.email != editUser.email ||
        userImage.value != null) {
      isChanged.value = true;
    } else {
      isChanged.value = false;
    }
  }

  Future<void> updateUser() async {
    if (!isChanged.value) {
      return;
    }

    isLoading.value = true;

    try {
      final _uid = currentUser.uid;

      String? newUrl;

      if (userImage.value != null) {
        newUrl = await StorageSeavice.uploadStorage(
          ref: StorageRef.profile,
          path: "$_uid",
          file: userImage.value!,
        );

        editUser.imageUrl = newUrl;
      }

      /// email update
      if (currentUser.email != editUser.email) {
        final _credential = await AuthController.to.auth.currentUser!
            .reauthenticateWithCredential(
          EmailAuthProvider.credential(
              email: currentUser.email, password: passwordController.text),
        );

        if (_credential.user != null) {
          await _credential.user!.updateEmail(editUser.email);
          print("updateEmail");
        }
      }

      await firebaseRef(FirebaseRef.user).doc(_uid).set(
            editUser.toMap(),
            SetOptions(merge: true),
          );

      AuthController.to.currentUser = editUser;
      MainTabController.to.pages.removeLast();
      MainTabController.to.pages.add(
        UserDetailScreen(user: AuthController.to.current),
      );
      Get.back(result: editUser);
    } catch (e) {
      showError(e);
    } finally {
      isLoading.value = false;
    }
  }
}
