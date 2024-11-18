import 'package:blog_app/core/utils/custom_toast.dart';
import 'package:blog_app/src/views/screens/auth/verify_number.dart';
import 'package:blog_app/src/views/widgets/customTextField.dart';
import 'package:blog_app/src/views/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneSignin extends StatefulWidget {
  const PhoneSignin({super.key});

  @override
  State<PhoneSignin> createState() => _PhoneSigninState();
}

class _PhoneSigninState extends State<PhoneSignin> {
  final _auth = FirebaseAuth.instance;
  final mobileController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Mobile Auth"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CustomTextField(
              hintText: "Mobile",
              controller: mobileController,
            ),
            const SizedBox(
              height: 25,
            ),
            CustomButton(
              label: "Send OTP",
              onTap: () {
                _auth.verifyPhoneNumber(
                    phoneNumber: mobileController.text,
                    verificationCompleted: (_) {},
                    verificationFailed: (e) {
                      Utils.customToast(e.toString());
                    },
                    codeSent: (String verficationId, int? token) {
                      Get.to(() => VerifyPhone(verficationId: verficationId));
                    },
                    codeAutoRetrievalTimeout: (e) {
                      Utils.customToast(e.toString());
                    });
              },
            )
          ]),
        ));
  }
}
