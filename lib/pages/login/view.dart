import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/pages/login/loginpage_index.dart';

class LoginPage extends GetView<LoginPageController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Form(
              key: controller.state.formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/login.png',
                      width: Get.width - 100,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Icon(
                        Icons.alternate_email,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        width: Get.width - 100,
                        child: TextFormField(
                          controller: controller.state.email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Email ID',
                          ),
                          validator: (val) {
                            if (!GetUtils.isEmail(val!))
                              return '*Invalid Email';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        width: Get.width - 100,
                        child: Obx(() {
                          return TextFormField(
                            controller: controller.state.password,
                            obscureText: controller.state.obscurePassword.value,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                hintText: 'Password',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.state.obscurePassword.value =
                                        !controller.state.obscurePassword.value;
                                  },
                                  icon: Icon(
                                      controller.state.obscurePassword.value
                                          ? Icons.visibility_off
                                          : Icons.visibility_rounded),
                                  padding: EdgeInsets.zero,
                                )),
                            validator: (val) {
                              if (val!.length < 6) return '*Invalid Password';
                              return null;
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Spacer(),
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: ColorConstants.purple_clr,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(height: 25),
                  Obx(() {
                    return controller.state.isLoading.value
                        ? Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(),
                            ),
                        )
                        : ElevatedButton(
                            onPressed: () async {
                              controller.login(controller.state.email.text,
                                  controller.state.password.text);
                            },
                            child: Text('Login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.purple_clr,
                              foregroundColor: Colors.white,
                              fixedSize: Size(Get.width, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
