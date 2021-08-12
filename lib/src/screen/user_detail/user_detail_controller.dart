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
  final Rx<FBUser> user;
  final AuthController auth = Get.find();

  final CreateRecentService cR = CreateRecentService();
  UserDetailController({required this.user});

  @override
  void onInit() {
    super.onInit();
  }

  void updateEditedUser(FBUser editedUser) {
    user.value = editedUser;
    update();
  }

  Future<void> startPrivateChat() async {
    if (user.value.isCurrent) {
      return;
    }

    final chatRoomId = await cR.createChatRoom(AuthController.to.current.uid,
        user.value.uid, [AuthController.to.current, user.value]);

    /// present message screen

    Get.until((route) => route.isFirst);
    // Get.find<MainTabController>().setIndex(0);

    final arguments = [
      chatRoomId,
      [user.value],
    ];
    Get.toNamed(MessageScreen.routeName, arguments: arguments);
  }
}
