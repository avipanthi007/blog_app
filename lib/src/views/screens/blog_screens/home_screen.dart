import 'package:blog_app/core/utils/contants.dart';
import 'package:blog_app/core/utils/custom_toast.dart';
import 'package:blog_app/services/firebase/firebase_services.dart';
import 'package:blog_app/src/controllers/blog_controller.dart';
import 'package:blog_app/src/models/blog_model.dart';
import 'package:blog_app/src/views/screens/blog_screens/add_new_blog.dart';
import 'package:blog_app/src/views/screens/auth/log_in.dart';
import 'package:blog_app/src/views/screens/blog_screens/view_blog.dart';
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
  FirebaseServices firebaseServices = FirebaseServices();

  final blogController = Get.find<BlogController>();
  final isLoading = true.obs;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    blogController.fetchBlogs();
    return PopScope(
      canPop: true,
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
                      firebaseServices.logOutUser();
                    },
                    title: const Text("Log Out"),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),
          ],
        ),
        body: Obx(() {
          if (blogController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (blogController.items.isEmpty) {
            return Center(child: Text('No blogs found.'));
          } else {
            return ListView.builder(
                itemCount: blogController.items.length,
                itemBuilder: (context, index) {
                  final item = blogController.items[index];
                  return Dismissible(
                    key: Key(item.id ?? "untitled"),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (value) {
                      blogController.blogDelete(item.id);

                      Utils.customToast("${item.title}deleted");
                    },
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                            () => ViewBlog(
                                  blog: item,
                                ),
                            transition: Transition.zoom,
                            duration: Duration(seconds: 1));
                      },
                      child: Stack(children: [
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
                              item.imageUrl,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 10,
                            child: Container(
                              width: 100.w,
                              padding: EdgeInsets.all(10),
                              color: Colors.transparent.withOpacity(0.2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(item.title, style: customTextStyle()),
                                  Text(
                                    item.category,
                                    style: customTextStyle(),
                                  ),
                                  Text(item.description,
                                      style: customTextStyle()),
                                ],
                              ),
                            )),
                      ]),
                    ),
                  );
                });
          }
        }),
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
        setState(() {});
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
// Expanded(
//               child: StreamBuilder(
//                   stream: blogController.ref.onValue,
//                   builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//                     if (!snapshot.hasData) {
//                       return Center(child: CircularProgressIndicator());
//                     } else {
//                       Map<dynamic, dynamic> map =
//                           snapshot.data!.snapshot.value ?? {} as dynamic;
//                       List<dynamic> list = map.values.toList();
//                       return ListView.builder(
//                         itemCount: snapshot.data!.snapshot.children.length,
//                         itemBuilder: (context, index) {
//                           return Dismissible(
//                             key: Key(list[index]["id"] ?? "untitled"),
//                             background: Container(
//                               color: Colors.red,
//                               alignment: Alignment.centerRight,
//                               padding: EdgeInsets.symmetric(horizontal: 20),
//                               child: Icon(Icons.delete, color: Colors.white),
//                             ),
//                             onDismissed: (value) {
//                               setState(() {
//                                 blogController.ref
//                                     .child(list[index]["id"])
//                                     .remove();
//                               });

//                               Get.snackbar(
//                                   "Message", list[index]["title"] + "deleted");
//                             },
//                             child: Stack(
//                               children: [
//                                 Container(
//                                   margin: EdgeInsets.all(10),
//                                   height: 200,
//                                   width: 100.w,
//                                   decoration: BoxDecoration(
//                                     color: Colors.black45.withOpacity(0.3),
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(12),
//                                     child: Image.network(
//                                       list[index]['image'],
//                                       fit: BoxFit.fill,
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   bottom: 10,
//                                   child: Container(
//                                     width: 100.w,
//                                     padding: EdgeInsets.all(10),
//                                     color: Colors.transparent.withOpacity(0.2),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           list[index]['title'],
//                                           style: const TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                         Text(
//                                           list[index]['category'],
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                         Text(
//                                           list[index]['description'],
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           );
//                         },
//                       );
//                     }
//                   }),
//             ),