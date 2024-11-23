import 'package:blog_app/core/utils/custom_toast.dart';
import 'package:blog_app/src/models/blog_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class BlogController extends GetxController {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Blogs');
  var items = <BlogModel>[].obs;
  var isLoading = true.obs;

  Future<void> fetchBlogs() async {
    try {
      isLoading.value = true;

      final snapshot = await databaseRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        items.value = data.entries.map((entry) {
          final blogData = Map<String, dynamic>.from(entry.value as Map);
          return BlogModel.fromMap(blogData, entry.key);
        }).toList();
      } else {
        items.clear();
      }
    } catch (e) {
      Logger().e('Error fetching blogs: $e');
      Utils.customToast('Failed to load blogs');
    } finally {
      isLoading.value = false;
      update();
    }
  }
  

  blogDelete(index) {
    databaseRef.child(index).remove();
  }
}
