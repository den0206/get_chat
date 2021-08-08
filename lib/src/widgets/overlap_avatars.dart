import 'package:flutter/material.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';

class OverlapAvatars extends StatelessWidget {
  const OverlapAvatars({
    Key? key,
    required this.users,
    this.size = 40,
  }) : super(key: key);

  final List<FBUser> users;

  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        height: size,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: users.length,
          itemBuilder: (context, index) {
            return Align(
              widthFactor: 0.4,
              child: Container(
                height: size,
                width: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: getUserImage(users[index]),
                    // fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
