import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_chat/src/screen/edit_user/edit_user_controller.dart';
import 'package:getx_chat/src/screen/network_branch.dart/network_branch.dart';
import 'package:getx_chat/src/utils/firebaseRef.dart';
import 'package:getx_chat/src/widgets/custom_button.dart';
import 'package:getx_chat/src/widgets/custom_textfield.dart';

class EditUserScreen extends GetView<EditUserCotroller> {
  EditUserScreen({Key? key}) : super(key: key);

  static const routeName = '/EditUser';
  final _formKey = GlobalKey<FormState>(debugLabel: '_EditUserState');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text(
          "Edit User",
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 27, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Obx(
                        () => CircleImageButton(
                          imageProvider: controller.userImage.value == null
                              ? getUserImage(controller.editUser)
                              : FileImage(controller.userImage.value!),
                          onTap: () {
                            controller.selectImage();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      CustomTextField(
                        controller: controller.nameTextControlller,
                        labelText: "name",
                        icon: Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                        onChange: (text) {
                          controller.editUser.name = text;
                          controller.checkChanged();
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        controller: controller.emailController,
                        labelText: "Email",
                        icon: Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                        onChange: (text) {
                          controller.editUser.email = text;
                          controller.checkChanged();
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Obx(() => controller.emailChange.value
                          ? Container(
                              child: FadeinWidget(
                                child: Column(
                                  children: [
                                    Text(
                                      "Want to Password",
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                    CustomTextField(
                                      controller: controller.passwordController,
                                      labelText: "Password",
                                      isSecure: true,
                                      icon: Icon(
                                        Icons.lock,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : SizedBox.shrink()),
                      Spacer(),
                      Obx(
                        () => CustomButton(
                          width: MediaQuery.of(context).size.width - 200,
                          title: "Edit",
                          isLoading: controller.isLoading.value,
                          background: Colors.green,
                          onPressed: controller.isChanged.value
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    print("Edit");
                                    FocusScope.of(context).unfocus();
                                    controller.updateUser();
                                  }
                                }
                              : null,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
