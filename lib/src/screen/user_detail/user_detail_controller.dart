import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:get/get.dart';

class UserDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(UserDetailController());
  }
}

class UserDetailController extends GetxController {
  final FBUser user = Get.arguments;

  @override
  void onInit() {
    super.onInit();
  }
}
