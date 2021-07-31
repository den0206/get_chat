import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/user_detail/base_widget.dart';
import 'package:getx_chat/src/screen/widgets/custom_dialog.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../root.dart';

class NetworkManager extends GetxService {
  Rx<InternetConnectionStatus> status = InternetConnectionStatus.connected.obs;
  InternetConnectionChecker _internetChecker = InternetConnectionChecker();

  static NetworkManager get to => Get.find();

  @override
  void onInit() {
    status.bindStream(_internetChecker.onStatusChange);
    ever(status, (value) {});
    super.onInit();
  }

  bool chackNetwork() {
    if (status.value == InternetConnectionStatus.disconnected) {
      final Exception error = Exception("No Internet");
      showError(error);
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    Get.back();
    status.close();
    super.onClose();
  }
}

class NetworkBranch extends StatelessWidget {
  const NetworkBranch({Key? key}) : super(key: key);

  static const routeName = '/NetworkBranch';

  @override
  Widget build(BuildContext context) {
    return GetX<NetworkManager>(
      init: NetworkManager(),
      builder: (manager) {
        return Scaffold(
          body: Stack(
            // fit: StackFit.expand,
            children: [
              Root(),
              if (manager.status.value == InternetConnectionStatus.disconnected)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: FadeinWidget(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(color: Colors.black),
                      child: Center(
                        child: Text(
                          "No Internet",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
