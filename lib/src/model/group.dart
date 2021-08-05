import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';

class Group {
  ///chatRoomid
  final String id;
  final String ownerId;
  final String? title;
  final List<FBUser> members;

  bool get isOwner {
    return ownerId == AuthController.to.current.uid;
  }

  Group({
    required this.id,
    required this.ownerId,
    required this.members,
    this.title,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      GroupKey.id: id,
      GroupKey.ownerId: ownerId,
      GroupKey.memberIds: members.map((user) => user.uid).toList(),
    };

    if (title != null) {
      map[GroupKey.title] = title;
    }

    return map;
  }
}

class GroupKey {
  static final String kGroup = "GroupCollection";

  static final String id = "id";
  static final String ownerId = "ownerId";
  static final String title = "title";
  static final String memberIds = "memberIds";
}
