import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/user_detail/user_detail_controller.dart';
import 'package:getx_chat/src/screen/widgets/custom_button.dart';

class UserDetailScreen extends GetView<UserDetailController> {
  const UserDetailScreen({
    Key? key,
  }) : super(key: key);

  static const routeName = '/UserDetail';

  @override
  Widget build(BuildContext context) {
    final Size responsive = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.user.name),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.zero,
                  height: responsive.height * 0.2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://picsum.photos/500/200",
                      ),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      repeat: ImageRepeat.noRepeat,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    padding: EdgeInsets.only(top: responsive.width * 0.3),
                    child: Card(
                      elevation: 5,
                      color: Colors.transparent,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          top: responsive.height * 0.13,
                          bottom: responsive.height * 0.03,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              controller.user.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40.0,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: responsive.height * 0.02,
                            ),
                            Text(
                              controller.user.email,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: responsive.height * 0.03,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButton(
                                  title: "Chat",
                                  background: Colors.green,
                                  onPressed: () {
                                    controller.createRecents();
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 10,
                  shape: CircleBorder(),
                  color: Colors.transparent,
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(
                      top: responsive.height * 0.02,
                    ),
                    child: Center(
                      child: Hero(
                        tag: controller.user.uid,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: responsive.width * 0.25,
                          backgroundImage: controller.user.imageUrl.isEmpty
                              ? Image.asset("assets/images/defaultDark.png")
                                  .image
                              : NetworkImage(
                                  controller.user.imageUrl,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
