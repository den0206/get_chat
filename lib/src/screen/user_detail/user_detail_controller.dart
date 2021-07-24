import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';

class UserDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(UserDetailController());
  }
}

class UserDetailController extends GetxController {
  final FBUser user = Get.arguments;

  bool get isCurrent => user.uid == current.uid;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> createRecents() async {
    if (isCurrent) {
      return;
    }

    print(user.uid);
    print(current.uid);

    Get.back();
  }
}
