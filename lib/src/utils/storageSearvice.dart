import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum StorageRef { profile, source }

extension StorageRefExtension on StorageRef {
  String get path {
    switch (this) {
      case StorageRef.profile:
        return "Profile";
      case StorageRef.source:
        return "Source";

      default:
        return "";
    }
  }
}

Reference storageRef(StorageRef ref) {
  return FirebaseStorage.instance.ref().child(ref.path);
}

enum UploadType { video, image }

class StorageSeavice {
  static Future<String> uploadStorage({
    required StorageRef ref,
    required String path,
    required File file,
    UploadType type = UploadType.image,
    bool showValue = false,
  }) async {
    Reference filePath = storageRef(ref).child(path);
    UploadTask uploadTask;
    RxDouble _progress = 0.0.obs;

    if (type == UploadType.image) {
      uploadTask = filePath.putFile(file);
    } else {
      uploadTask = filePath.putFile(
        file,
        SettableMetadata(contentType: 'video/mp4'),
      );
    }

    if (showValue) {
      uploadTask.snapshotEvents.listen((event) {
        _progress.value =
            event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
      });

      Get.dialog(
        Obx(
          () => Container(
            decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
            child: Center(
              child: SizedBox(
                width: 300,
                child: LinearProgressIndicator(
                  value: _progress.value,
                ),
              ),
            ),
          ),
        ),
      );
    }

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
      if (showValue) Get.back();
    });

    String dlurl = await taskSnapshot.ref.getDownloadURL();
    return dlurl.toString();
  }
}
