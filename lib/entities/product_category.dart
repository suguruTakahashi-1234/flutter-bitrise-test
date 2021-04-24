import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCategory {
  int id;
  String name;

  ProductCategory(DocumentSnapshot doc) {
    id = doc.data()['id'];
    name = doc.data()['name'];
  }
}
