import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_chat/src/screen/edit_user/edit_user_controller.dart';

class EditUserScreen extends GetView<EditUserCotroller> {
  const EditUserScreen({Key? key}) : super(key: key);

  static const routeName = '/EditUser';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            controller.currentUser == controller.editUser ? "true" : "false"),
      ),
      body: Container(),
    );
  }
}
