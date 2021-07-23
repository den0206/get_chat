import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/user_detail/user_detail_controller.dart';

class UserDetailScreen extends GetView<UserDetailController> {
  const UserDetailScreen({
    Key? key,
  }) : super(key: key);

  static const routeName = '/UserDetail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.user.name),
      ),
      body: Container(),
    );
  }
}
