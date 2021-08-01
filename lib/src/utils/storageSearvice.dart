import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

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
  }) async {
    Reference filePath = storageRef(ref).child(path);
    UploadTask uploadTask;

    if (type == UploadType.image) {
      uploadTask = filePath.putFile(file);
    } else {
      uploadTask = filePath.putFile(
        file,
        SettableMetadata(contentType: 'video/mp4'),
      );
    }

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String dlurl = await taskSnapshot.ref.getDownloadURL();
    return dlurl.toString();
  }
}
