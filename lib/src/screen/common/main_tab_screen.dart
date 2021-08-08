import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx_chat/src/screen/common/main_tab_controller.dart';
import 'package:getx_chat/src/widgets/loading_widget.dart';

class MainTabScreen extends StatelessWidget {
  const MainTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainTabController>(
      init: MainTabController(),
      builder: (controller) {
        return OverlayLoadingWidget(
          isLoading: controller.isLoading,
          child: Scaffold(
            body: controller.pages[controller.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.grey,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              onTap: controller.setIndex,
              selectedItemColor: Colors.black,
              currentIndex: controller.currentIndex,
              items: controller.bottomItems,
            ),
          ),
        );
      },
    );
  }
}
