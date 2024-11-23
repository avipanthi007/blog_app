import 'package:blog_app/core/utils/contants.dart';
import 'package:blog_app/src/controllers/blog_controller.dart';
import 'package:blog_app/src/models/blog_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ViewBlog extends StatefulWidget {
  BlogModel blog;
  ViewBlog({super.key, required this.blog});

  @override
  State<ViewBlog> createState() => _ViewBlogState();
}

class _ViewBlogState extends State<ViewBlog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.blog.title),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 35.h,
            width: 100.w,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
              child: Image.network(
                widget.blog.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Title : ${widget.blog.title}",
                  style: customTextStyle(textColor: Colors.black, fontSize: 18),
                ),
                Divider(),
                Text(
                  "Category : ${widget.blog.category}",
                  style: customTextStyle(textColor: Colors.black, fontSize: 18),
                ),
                Divider(),
                Text(
                  "Description : ${widget.blog.description}",
                  style: customTextStyle(textColor: Colors.black, fontSize: 18),
                ),
                Divider(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
