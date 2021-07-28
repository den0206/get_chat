import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/model/message.dart';

class MessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MessageController());
  }
}

class MessageController extends GetxController {
  final String chatRoomId = Get.arguments[0];
  final FBUser withUser = Get.arguments[1];

  final messages = <Message>[].obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();

    // scrollController.jumpTo(0);
  }
}
