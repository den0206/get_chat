import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_chat/src/screen/auth/auth_controller.dart';
import 'package:getx_chat/src/screen/common/main_tab_controller.dart';

class HomeController extends GetxController {
  final auth = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> testLoading() async {
    MainTabController.to.setLoading(true);

    await Future.delayed(Duration(seconds: 3));

    MainTabController.to.setLoading(false);
  }
}
