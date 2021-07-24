import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/screen/widgets/custom_dialog.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';

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

  File? userImage;

  final authControllr = Get.find<AuthController>();

  final _auth = FirebaseAuth.instance;

  String get _name => nameTextControlller.text;
  String get _email => emailController.text;
  String get _password => passwordController.text;

  RxBool isLoading = false.obs;

  Future<void> register() async {
    isLoading.value = true;

    if (userImage == null) {
      Exception error = Exception("No Image");
      showError(error);
      return;
    }

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

        authControllr.currentUser = user;

        print("Success");
      }
    } catch (e) {
      showError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectImage() async {
    List<Asset> results = <Asset>[];
    try {
      results = await MultiImagePicker.pickImages(
        maxImages: 1,
        selectedAssets: results,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      final File file = await getImageFileFromAssets(results.first);
      userImage = file;
    } catch (e) {
      showError(e);
    }
  }

  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    return file;
  }
}
