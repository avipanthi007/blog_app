import 'package:blog_app/core/utils/custom_toast.dart';
import 'package:blog_app/src/views/screens/blog_screens/home_screen.dart';
import 'package:blog_app/src/views/screens/profile/upload_profile.dart';
import 'package:blog_app/src/views/widgets/customTextField.dart';
import 'package:blog_app/src/views/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final obsecure = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LottieBuilder.asset(
                  'assets/lottie/blog.json',
                  height: 250,
                  width: 250.w,
                ),
                const Row(
                  children: [
                    Text(
                      "Sign",
                      style:
                          TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Up",
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
                    hintText: "Password",
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
                  label: "Sign Up",
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      _auth
                          .createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text)
                          .then((value) {
                        Get.to(() => UploadProfile());
                        Utils.customToast("Register Success");
                      }).onError((errore, stackTrace) {
                        Utils.customToast(errore.toString());
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
