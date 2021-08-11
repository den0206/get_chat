import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_chat/src/model/fb_user.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';

class EditUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditUserCotroller());
  }
}

class EditUserCotroller extends GetxController {
  final FBUser currentUser = AuthController.to.current;
  late final FBUser editUser;

  @override
  void onInit() {
    super.onInit();

    editUser = currentUser.copyWith();
    editUser.name = "aaa1adfa";
  }
}
