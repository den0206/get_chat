import 'package:flutter/material.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';

class OverlapAvatars extends StatelessWidget {
  const OverlapAvatars({
    Key? key,
    required this.users,
  }) : super(key: key);

  final List<FBUser> users;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        height: 50,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: users.length,
          itemBuilder: (context, index) {
            return Align(
              widthFactor: 0.4,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                backgroundImage: getUserImage(users[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
