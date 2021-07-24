import 'package:cloud_firestore/cloud_firestore.dart';

class FBUser {
  String uid;
  String name;
  String email;
  String imageUrl;

  FBUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageUrl,
  });

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
}

class UserKey {
  static final uid = "uid";
  static final name = "name";
  static final email = "email";
  static final imageUrl = "imageUrl";
}
