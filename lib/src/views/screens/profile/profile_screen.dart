import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ref = FirebaseDatabase.instance.ref("Data");

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FirebaseAnimatedList(
          query: ref,
          itemBuilder: (context, snapshot, animated, index) {
            if (snapshot != null) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 300,
                    width: 100.w,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        snapshot.child('profile').value.toString(),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  kRepeatedContainer(
                      snapshot, "Name : ${snapshot.child('name').value}"),
                  kRepeatedContainer(
                      snapshot, "Mobile : ${snapshot.child('mobile').value}"),
                  kRepeatedContainer(
                      snapshot, "Address : ${snapshot.child('address').value}"),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Container kRepeatedContainer(DataSnapshot snapshot, String title) {
    return Container(
        height: 07.h,
        padding: EdgeInsets.all(10),
        width: Get.width,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), border: Border.all()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            ),
          ],
        ));
  }
}
