import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:getx_chat/src/model/fb_user.dart';

enum FirebaseRef { user, recent, message }

extension FirebaseRefExtension on FirebaseRef {
  String get path {
    switch (this) {
      case FirebaseRef.user:
        return "User";
      case FirebaseRef.recent:
        return "Recent";
      case FirebaseRef.message:
        return "Message";

      default:
        return "";
    }
  }
}

CollectionReference firebaseRef(FirebaseRef ref) {
  return FirebaseFirestore.instance.collection(ref.path);
}

ImageProvider getUserImage(FBUser user) {
  if (user.imageUrl.isEmpty) {
    return Image.asset("assets/images/defaultDark.png").image;
  } else {
    return NetworkImage(user.imageUrl);
  }
}
