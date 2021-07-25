import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_chat/src/screen/recent/recents_controller.dart';

class RecentsScreen extends StatelessWidget {
  const RecentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recents'),
      ),
      body: GetX<RecentsController>(
        init: RecentsController(),
        builder: (controller) {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemCount: controller.recents.length,
            itemBuilder: (BuildContext context, int index) {
              final recent = controller.recents[index];

              return Text(recent.id);
            },
          );
        },
      ),
    );
  }
}
