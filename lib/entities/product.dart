import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  int id;
  int categoryId;
  String name;
  int price;
  String description;
  String imageUrl;
  int count;

  Product(DocumentSnapshot doc) {
    id = doc.data()['id'];
    categoryId = doc.data()['category_id'];
    name = doc.data()['name'];
    price = doc.data()['price'];
    description = doc.data()['description'];
    imageUrl = doc.data()['image_url'];
  }

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    price = json['price'];
    description = json['description'];
    imageUrl = json['image_url'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category_id': categoryId,
        'name': name,
        'price': price,
        'description': description,
        'image_url': imageUrl,
        'count': count,
      };
}
