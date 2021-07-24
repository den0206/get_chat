import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_chat/src/screen/auth/login/login_screen.dart';
import 'package:getx_chat/src/screen/auth/signup/signup_controller.dart';
import 'package:getx_chat/src/screen/widgets/custom_button.dart';
import 'package:getx_chat/src/screen/widgets/custom_textfield.dart';
import 'package:getx_chat/src/screen/widgets/images_crousel.dart';

class SignUpScreen extends GetView<SignUpController> {
  SignUpScreen({Key? key}) : super(key: key);
  static const routeName = '/SignUp';
  final _formKey = GlobalKey<FormState>(debugLabel: '_SignUpState');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            height: 300,
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 22,
                          ),
                          ImagesCroisel(
                            images: [
                              "https://picsum.photos/300",
                              "https://picsum.photos/200"
                            ],
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "SignUp",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Welcome",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 27, vertical: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Obx(
                              () => CircleImageButton(
                                imageProvider: controller.userImage.value ==
                                        null
                                    ? Image.asset(
                                            "assets/images/defaultDark.png")
                                        .image
                                    : FileImage(controller.userImage.value!),
                                onTap: () {
                                  controller.selectImage();
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            CustomTextField(
                              controller: controller.nameTextControlller,
                              labelText: "name",
                              icon: Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            CustomTextField(
                              controller: controller.emailController,
                              labelText: "Email",
                              icon: Icon(
                                Icons.email,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            CustomTextField(
                              controller: controller.passwordController,
                              labelText: "Password",
                              isSecure: true,
                              icon: Icon(
                                Icons.lock,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Obx(
                              () => CustomButton(
                                title: "Sigh Up",
                                isLoading: controller.isLoading.value,
                                background: Colors.green,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    controller.register();
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextButton(
                              onPressed: () {
                                Get.offAndToNamed(LoginScreen.routeName);
                              },
                              child: Text("Login"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
