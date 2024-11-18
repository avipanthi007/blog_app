import 'dart:io';

import 'package:blog_app/core/utils/custom_toast.dart';
import 'package:blog_app/src/views/widgets/customTextField.dart';
import 'package:blog_app/src/views/widgets/custom_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class UpdateBlog extends StatefulWidget {
  const UpdateBlog({super.key});

  @override
  State<UpdateBlog> createState() => _UpdateBlogState();
}

class _UpdateBlogState extends State<UpdateBlog> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Blogs');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  Future pickGalleryImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Utils.customToast("Image Not Selected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update  Blog"),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    pickGalleryImage();
                  },
                  child: Center(
                    child: Container(
                      height: 200,
                      width: 100.w,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(12)),
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _image!.absolute,
                                fit: BoxFit.fill,
                              ),
                            )
                          : const Icon(Icons.image),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextField(
                  controller: titleController,
                  hintText: "title",
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextField(
                  controller: categoryController,
                  hintText: "Category",
                  //keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextField(
                  controller: descriptionController,
                  maxLines: 3,
                  hintText: "Description",
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomButton(
                  label: "ADD",
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      firebase_storage.Reference ref = await firebase_storage
                          .FirebaseStorage.instance
                          .ref('images/')
                          .child(
                              DateTime.now().microsecondsSinceEpoch.toString());
                      firebase_storage.UploadTask uploadTask =
                          ref.putFile(_image!.absolute);
                      await Future.value(uploadTask).then((value) async {
                        var newUrl = await ref.getDownloadURL();
                        String id =
                            DateTime.now().microsecondsSinceEpoch.toString();
                        databaseRef.child(id).set({
                          'id': id,
                          'title': titleController.text,
                          'category': categoryController.text,
                          'description': descriptionController.text,
                          'image': newUrl.toString()
                        }).then((value) { 
                          Utils.customToast("Post Uploaded..!");
                          Get.back();
                        }).onError((errore, stacktrace) {
                          Utils.customToast(errore.toString());
                        });
                      }).onError((errore, stackTrace) {
                        Utils.customToast(errore.toString());
                      });
                    }
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
