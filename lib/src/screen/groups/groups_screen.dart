import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_chat/src/model/group.dart';
import 'package:getx_chat/src/screen/group_detail/group_detail_screen.dart';
import 'package:getx_chat/src/screen/groups/groups_controller.dart';
import 'package:getx_chat/src/widgets/overlap_avatars.dart';
import 'package:get/get.dart';

class GroupsScreen extends GetView<GroupsController> {
  const GroupsScreen({Key? key}) : super(key: key);
  static const routeName = '/Group';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
      ),
      body: Obx(
        () => ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemCount: controller.groups.length,
          itemBuilder: (BuildContext context, int index) {
            final group = controller.groups[index];
            return GroupCell(group: group);
          },
        ),
      ),
    );
  }
}

class GroupCell extends StatelessWidget {
  const GroupCell({
    Key? key,
    required this.group,
  }) : super(key: key);

  final Group group;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(GroupDetailScreen.routeName, arguments: group);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: [
            OverlapAvatars(
              users: group.members,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              group.title != null ? group.title! : group.id,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
