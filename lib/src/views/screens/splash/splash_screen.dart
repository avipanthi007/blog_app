import 'dart:async';

import 'package:blog_app/services/firebase/firebase_services.dart';
import 'package:blog_app/src/views/screens/auth/log_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseServices services = FirebaseServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    services.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LottieBuilder.asset(
          'assets/lottie/blog.json',
          height: 300,
          width: 300.w,
        ),
      ),
    );
  }
}
