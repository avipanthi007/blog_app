import 'package:blog_app/core/utils/custom_toast.dart';
import 'package:blog_app/src/views/widgets/customTextField.dart';
import 'package:blog_app/src/views/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class PasswordResetEmailLink extends StatefulWidget {
  const PasswordResetEmailLink({super.key});

  @override
  State<PasswordResetEmailLink> createState() => _PasswordResetEmailLinkState();
}

class _PasswordResetEmailLinkState extends State<PasswordResetEmailLink> {
  final _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forget Password")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              controller: emailController,
              hintText: "Enter Email @",
            ),
            SizedBox(
              height: 25,
            ),
            CustomButton(
              label: "Send Link",
              onTap: () {
                _auth
                    .sendPasswordResetEmail(email: emailController.text)
                    .then((value) {
                  Navigator.pop(context);
                  Utils.customToast("Link Sent on Email");
                }).onError((errore, stackTrace) {
                  Utils.customToast(errore.toString());
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
