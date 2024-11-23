import 'dart:async';
import 'dart:io';

import 'package:blog_app/core/local_storage/shared_pref.dart';
import 'package:blog_app/core/utils/custom_toast.dart';
import 'package:blog_app/src/views/screens/auth/log_in.dart';
import 'package:blog_app/src/views/screens/blog_screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseServices {
  final auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Blogs');
  File? _image;
  RxBool isLoading = false.obs;

  isLogin(context) async {
    bool checkLogin = await LocalStorage().getLoginStatus();
    if (checkLogin) {
      Timer(Duration(seconds: 3), () {
        Get.offAll(() => HomeScreen());
      });
    } else {
      Timer(Duration(seconds: 3), () {
        Get.offAll(() => LogIn());
      });
    }
  }

  logOutUser() async {
    auth.signOut().then((value) {
      Utils.customToast("Logged Out");
      LocalStorage().setLoginStatus(false);
      Get.offAll(() => const LogIn());
    }).onError((error, stackTrace) {
      Utils.customToast(error.toString());
    });
  }

  signInWithEmailPassword(
      {required String email, required String password}) async {
    auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      Get.to(() => HomeScreen());
      LocalStorage().setLoginStatus(true);
      Utils.customToast("Login Success");
    }).onError((errore, stackTrace) {
      Utils.customToast(errore.toString());
    });
  }

  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await account.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        await auth.signInWithCredential(authCredential).then((value) {
          Get.to(() => HomeScreen());
          LocalStorage().setLoginStatus(true);
          Utils.customToast("Login Success");
        }).onError((errore, stackTrack) {
          Utils.customToast(errore.toString());
        });
      }
    } catch (e) {
      Utils.customToast("Some Errore $e");
    }
  }

  uploadBlog({
    required String title,
    required String description,
    required String category,
    required File image,
  }) async {
    try {
      isLoading.value = true;

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('images/')
          .child(DateTime.now().microsecondsSinceEpoch.toString());

      firebase_storage.UploadTask uploadTask = ref.putFile(image.absolute);

      await uploadTask;

      var newUrl = await ref.getDownloadURL();

      String id = DateTime.now().microsecondsSinceEpoch.toString();

      await databaseRef.child(id).set({
        'id': id,
        'title': title,
        'category': category,
        'description': description,
        'image': newUrl.toString(),
      });
      isLoading.value = false;
      Utils.customToast("Post Uploaded!");
      Get.offAll(() => HomeScreen());
    } catch (error) {
      isLoading.value = false;
      Utils.customToast(error.toString());
    }
  }
}

class GetImageForFirestore {
  Future<void> getImage() async {
    ImagePicker().pickImage(source: ImageSource.gallery);
  }
}
