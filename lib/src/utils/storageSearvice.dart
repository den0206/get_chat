import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

enum StorageRef { profile }

extension StorageRefExtension on StorageRef {
  String get path {
    switch (this) {
      case StorageRef.profile:
        return "Profile";
      default:
        return "";
    }
  }
}

Reference storageRef(StorageRef ref) {
  return FirebaseStorage.instance.ref().child(ref.path);
}

class StorageSeavice {
  static Future<String> uploadStorage(
      StorageRef ref, String path, File file) async {
    Reference filePath = storageRef(ref).child(path);
    UploadTask uploadTask;

    uploadTask = filePath.putFile(file);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String dlurl = await taskSnapshot.ref.getDownloadURL();
    return dlurl.toString();
  }
}
