import 'dart:convert';

import 'package:blog_app/core/utils/custom_toast.dart';
import 'package:blog_app/src/views/screens/add_new_blog.dart';
import 'package:blog_app/src/views/screens/auth/log_in.dart';
import 'package:blog_app/src/views/screens/profile/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref("Blogs");
  final isLoading = true.obs;
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Blogs",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.menu),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: ListTile(
                    onTap: () {
                      Get.to(() => const ProfileScreen());
                    },
                    title: const Text("Profile"),
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    onTap: () {
                      _auth.signOut().then((value) {
                        Utils.customToast("Logged Out");
                        Get.offAll(() => const LogIn());
                      }).onError((error, stackTrace) {
                        Utils.customToast(error.toString());
                      });
                    },
                    title: const Text("Log Out"),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  kCategoryButton(),
                  kCategoryButton(),
                  kCategoryButton(),
                  kCategoryButton(),
                  kCategoryButton(),
                  kCategoryButton(),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: ref.onValue,
                  builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      Map<dynamic, dynamic> map =
                          snapshot.data!.snapshot.value ?? {} as dynamic;
                      List<dynamic> list = map.values.toList();
                      return ListView.builder(
                        itemCount: snapshot.data!.snapshot.children.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(list[index]["id"] ?? "untitled"),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (value) {
                              setState(() {
                                ref.child(list[index]["id"]).remove();
                              });

                              Get.snackbar(
                                  "Message", list[index]["title"] + "deleted");
                            },
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10),
                                  height: 200,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    color: Colors.black45.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      list[index]['image'],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 100,
                                  child: Container(
                                    width: 100.w,
                                    padding: EdgeInsets.all(10),
                                    color: Colors.transparent.withOpacity(0.2),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          list[index]['title'],
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          list[index]['category'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          list[index]['description'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }),
            ),
          ],
        ),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 20),
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton(
            onPressed: () {
              Get.to(() => const AddNewBlog());
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  InkWell kCategoryButton() {
    return InkWell(
      onTap: () {
        isSelected = !isSelected;
        setState(() {
          
        });
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        height: 05.h,
        width: 35.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? Colors.orange : Colors.grey),
      ),
    );
  }
}
