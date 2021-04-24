import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pre_order_flutter_app/entities/product.dart';

class Cart {
  int id;
  String publicationOrderId;
  int userId;
  int storeId;
  List<Product> products;
  int totalQuantity;
  int totalAmount;
  DocumentReference documentReference;

  Cart(DocumentSnapshot doc) {
    id = doc.data()['id'];
    publicationOrderId = doc.data()['publication_order_id'];
    userId = doc.data()['user_id'];
    storeId = doc.data()['store_id'];
    totalQuantity = doc.data()['total_quantity'];
    totalAmount = doc.data()['total_amount'];
    documentReference = doc.reference;
    products = <Product>[];
    if (doc.data()['products'] != null) {
      doc.data()['products'].forEach((v) {
        products.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'publication_order_id': publicationOrderId,
        'user_id': userId,
        'store_id': storeId,
        'products': products.map((product) => product.toJson()).toList(),
        'total_quantity': totalQuantity,
        'total_amount': totalAmount,
      };
}
