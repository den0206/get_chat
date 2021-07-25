import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/model/recent.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';

class UserDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(UserDetailController());
  }
}

class UserDetailController extends GetxController {
  final FBUser user = Get.arguments;
  final AuthController auth = Get.find();

  bool get isCurrent => user.uid == auth.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> startPrivateChat() async {
    if (isCurrent) {
      return;
    }

    final chatRoomId =
        await createChatRoom(current.uid, user.uid, [current, user]);
    print(chatRoomId);

    Get.back();
  }
}
