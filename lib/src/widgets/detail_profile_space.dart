import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:getx_chat/src/screen/user_detail/user_detail_controller.dart';

class DetailButtonSpace extends GetView<UserDetailController> {
  const DetailButtonSpace({
    Key? key,
    required this.actions,
  }) : super(key: key);

  final List<DetailIconButton> actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: actions,
    );
  }
}

class DetailIconButton extends StatelessWidget {
  const DetailIconButton({
    Key? key,
    required this.icon,
    required this.onTap,
    this.backColor = Colors.green,
    this.size = 60,
  }) : super(key: key);

  final IconData icon;
  final Function() onTap;
  final Color backColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
            color: backColor,
          ),
          child: Icon(
            icon,
            size: size / 1.7,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
