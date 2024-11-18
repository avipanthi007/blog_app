import 'package:blog_app/core/utils/custom_toast.dart';
import 'package:blog_app/src/views/screens/auth/mobile_login.dart';
import 'package:blog_app/src/views/screens/auth/password_reset_link.dart';
import 'package:blog_app/src/views/screens/auth/sign_up.dart';
import 'package:blog_app/src/views/screens/home_screen.dart';
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
                      _auth
                          .signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text)
                          .then((value) {
                        Get.to(() => const HomeScreen());
                        Utils.customToast("Login Success");
                      }).onError((errore, stackTrace) {
                        Utils.customToast(errore.toString());
                      });
                    }
                  },
                ),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PasswordResetEmailLink()));
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
                CustomButton(
                  label: "LogIn With Mobile",
                  onTap: () {
                    Get.to(() => const PhoneSignin());
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
