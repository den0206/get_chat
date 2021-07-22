import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_chat/src/screen/auth/login/login_controller.dart';
import 'package:getx_chat/src/screen/auth/signup/signup_screen.dart';
import 'package:getx_chat/src/screen/widgets/custom_button.dart';
import 'package:getx_chat/src/screen/widgets/custom_textfield.dart';
import 'package:getx_chat/src/screen/widgets/images_crousel.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<LoginController> {
  LoginScreen({Key? key}) : super(key: key);
  static const routeName = '/Login';
  final _formKey = GlobalKey<FormState>(debugLabel: '_LoginState');

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
                                  "Login",
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
                            CustomTextField(
                              controller: TextEditingController(),
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
                              controller: TextEditingController(),
                              labelText: "Password",
                              isSecure: true,
                              icon: Icon(
                                Icons.lock,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                child: Text(
                                  "Forgot password",
                                ),
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Obx(
                              () => CustomButton(
                                title: "Login",
                                isLoading: controller.isLoading.value,
                                onPressed: () {
                                  controller.loginUser();
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextButton(
                                onPressed: () {
                                  Get.offAndToNamed(SignUpScreen.routeName);
                                },
                                child: Text("Sign Up"))
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
