import 'package:blog_app/core/local_storage/shared_pref.dart';
import 'package:blog_app/core/utils/custom_toast.dart';
import 'package:blog_app/services/firebase/firebase_services.dart';
import 'package:blog_app/src/views/screens/auth/mobile_login.dart';
import 'package:blog_app/src/views/screens/auth/password_reset_link.dart';
import 'package:blog_app/src/views/screens/auth/sign_up.dart';
import 'package:blog_app/src/views/screens/blog_screens/home_screen.dart';
import 'package:blog_app/src/views/widgets/customTextField.dart';
import 'package:blog_app/src/views/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final obsecure = true.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                LottieBuilder.asset(
                  'assets/lottie/blog.json',
                  height: 250,
                  width: 250.w,
                ),
                const Row(
                  children: [
                    Text(
                      "Log",
                      style:
                          TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "In",
                      style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  controller: emailController,
                  hintText: "Email",
                ),
                const SizedBox(
                  height: 15,
                ),
                Obx(
                  () => CustomTextField(
                    controller: passwordController,
                    hintText: "Enter Password",
                    obsecureText: obsecure.isTrue,
                    suffix: IconButton(
                      onPressed: () {
                        obsecure.toggle();
                      },
                      icon: Icon(obsecure.isTrue
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                  label: "Log In",
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      FirebaseServices().signInWithEmailPassword(
                          email: emailController.text,
                          password: passwordController.text);
                    }
                  },
                ),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          Get.to(() => PasswordResetEmailLink());
                        },
                        child: const Text("Forget Password?"))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have account ? "),
                    TextButton(
                        onPressed: () {
                          Get.to(() => const SignupScreen());
                        },
                        child: const Text("SignUp"))
                  ],
                ),
                Divider(),
                CustomButton(
                  label: "LogIn With Mobile",
                  onTap: () {
                    Get.to(() => const PhoneSignin());
                  },
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    FirebaseServices().signInWithGoogle();
                  },
                  child: Container(
                      height: 55,
                      width: 100.w,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/google_icon.png",
                            height: 45,
                            width: 50,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text("Sign up with Google")
                        ],
                      )),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
