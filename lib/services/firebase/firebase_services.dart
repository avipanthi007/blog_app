import 'dart:async';

import 'package:blog_app/src/views/screens/auth/log_in.dart';
import 'package:blog_app/src/views/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseServices {
  final auth = FirebaseAuth.instance;

  isLogin(context) {
    if (auth.currentUser != null) {
      Timer(Duration(seconds: 3), () {
        Get.offAll(()=>HomeScreen());

      });
    } else {
      Timer(Duration(seconds: 3), () {
        Get.offAll(()=>LogIn());
       
      });
    }
  }
}

class GetImageForFirestore {
  Future<void> getImage() async {
    ImagePicker().pickImage(source: ImageSource.gallery);
  }
}
