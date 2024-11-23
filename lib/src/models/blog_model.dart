import 'dart:convert';

class BlogModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String imageUrl;

  BlogModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
  });

  // Converts BlogModel to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'image': imageUrl,
    };
  }

  // Factory method to create BlogModel from a Firebase map
  factory BlogModel.fromMap(Map<String, dynamic> map, String id) {
    return BlogModel(
      id: id, // Use Firebase key as ID
      title:
          map['title'] ?? '', // Default to an empty string if field is missing
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['image'] ?? '',
    );
  }

  // Converts BlogModel to a JSON string
  String toJson() => json.encode(toMap());
}
