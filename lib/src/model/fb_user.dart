import 'package:cloud_firestore/cloud_firestore.dart';

class FBUser {
  String uid;
  String name;
  String email;

  FBUser({
    required this.uid,
    required this.name,
    required this.email,
  });

  factory FBUser.fromMap(DocumentSnapshot doc) {
    return FBUser(
      name: doc[UserKey.name],
      uid: doc[UserKey.uid],
      email: doc[UserKey.email],
    );
  }

  Map<String, dynamic> toMap() {
    return {UserKey.uid: uid, UserKey.name: name, UserKey.email: email};
  }
}

class UserKey {
  static final uid = "uid";
  static final name = "name";
  static final email = "email";
}
