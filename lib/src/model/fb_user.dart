import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:getx_chat/src/screen/auth/auth_controller.dart';

class FBUser {
  String uid;
  String name;
  String email;
  String imageUrl;

  bool get isCurrent {
    return uid == AuthController.to.current.uid;
  }

  FBUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  String get avatarPath {
    return "$uid";
  }

  factory FBUser.fromMap(DocumentSnapshot doc) {
    return FBUser(
      name: doc[UserKey.name],
      uid: doc[UserKey.uid],
      email: doc[UserKey.email],
      imageUrl:
          (doc.data() as Map<String, dynamic>).containsKey(UserKey.imageUrl)
              ? doc[UserKey.imageUrl]
              : "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      UserKey.uid: uid,
      UserKey.name: name,
      UserKey.email: email,
      UserKey.imageUrl: imageUrl,
    };
  }

  FBUser copyWith({
    String? uid,
    String? name,
    String? email,
    String? imageUrl,
  }) {
    return FBUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class UserKey {
  static final uid = "uid";
  static final name = "name";
  static final email = "email";
  static final imageUrl = "imageUrl";
}
