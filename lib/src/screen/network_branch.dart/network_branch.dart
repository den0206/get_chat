import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../root.dart';

class NetworkManager extends GetxService {
  Rx<InternetConnectionStatus> status = InternetConnectionStatus.connected.obs;
  InternetConnectionChecker _internetChecker = InternetConnectionChecker();

  @override
  void onInit() {
    status.bindStream(_internetChecker.onStatusChange);
    ever(status, (value) {
      if (value as InternetConnectionStatus ==
          InternetConnectionStatus.disconnected) {
        print("No internet");
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
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
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 130,
                    decoration: BoxDecoration(color: Colors.black),
                    child: Center(
                      child: Text(
                        "No Internet",
                        style: TextStyle(color: Colors.white, fontSize: 20),
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
