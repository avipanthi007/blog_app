import 'dart:io';

import 'package:blog_app/core/utils/custom_toast.dart';
import 'package:blog_app/services/firebase/firebase_services.dart';
import 'package:blog_app/src/views/widgets/customTextField.dart';
import 'package:blog_app/src/views/widgets/custom_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class AddNewBlog extends StatefulWidget {
  const AddNewBlog({super.key});

  @override
  State<AddNewBlog> createState() => _AddNewBlogState();
}
//title,description,category,tags,imageUrl

class _AddNewBlogState extends State<AddNewBlog> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? image;
  final picker = ImagePicker();

  Future pickGalleryImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        Utils.customToast("Image Not Selected");
      }
    });
  }

  String _selectedValue = "Technology and Gadgets";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Blog"),
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
                      child: image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                image!.absolute,
                                fit: BoxFit.fill,
                              ),
                            )
                          : const Icon(Icons.image),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.2.h,
                ),
                CustomTextField(
                  controller: titleController,
                  hintText: "title",
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text('Technology'),
                        leading: Radio<String>(
                          value: "Technology",
                          groupValue: _selectedValue,
                          onChanged: (value) {
                            setState(() {
                              _selectedValue = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 45.w,
                      child: ListTile(
                        title: Text('Health'),
                        leading: Radio<String>(
                          value: "Health",
                          groupValue: _selectedValue,
                          onChanged: (value) {
                            setState(() {
                              _selectedValue = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text('Personal Finance'),
                        leading: Radio<String>(
                          value: "Personal Finance",
                          groupValue: _selectedValue,
                          onChanged: (value) {
                            setState(() {
                              _selectedValue = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 45.w,
                      child: ListTile(
                        title: Text('Travel'),
                        leading: Radio<String>(
                          value: "Travel",
                          groupValue: _selectedValue,
                          onChanged: (value) {
                            setState(() {
                              _selectedValue = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
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
                Obx(
                  () => FirebaseServices().isLoading.value
                      ? CircularProgressIndicator()
                      : CustomButton(
                          label: "ADD",
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              FirebaseServices().uploadBlog(
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  category: _selectedValue,
                                  image: image!);
                            }
                          },
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
