import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/screen/message/message_screen.dart';
import 'package:getx_chat/src/service/create_recent.dart';

// class UserDetailBinding implements Bindings {
//   @override
//   void dependencies() {
//     Get.put(UserDetailController());
//   }
// }

class UserDetailController extends GetxController {
  final FBUser user;
  final AuthController auth = Get.find();

  final CreateRecentService cR = CreateRecentService();
  UserDetailController({required this.user});

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> startPrivateChat() async {
    if (user.isCurrent) {
      return;
    }

    final chatRoomId = await cR.createChatRoom(AuthController.to.current.uid,
        user.uid, [AuthController.to.current, user]);

    /// present message screen
    // Get.back();
    Get.until((route) => route.isFirst);
    // Get.find<MainTabController>().setIndex(0);

    final arguments = [
      chatRoomId,
      [user],
    ];
    Get.toNamed(MessageScreen.routeName, arguments: arguments);
  }
}
