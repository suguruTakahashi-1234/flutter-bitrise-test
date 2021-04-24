import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pre_order_flutter_app/entities/product.dart';

class Order {
  int id;
  String timestamp;
  String publicationOrderId;
  int userId;
  int storeId;
  List<Product> products;
  int totalQuantity;
  int totalAmount;
  String receiveStoreName;
  String receiveTime;
  String receiveMethodName;
  String receiveMethodOrderMessage;
  String paymentMethodName;
  bool isReceived;
  DocumentReference documentReference;

  Order(DocumentSnapshot doc) {
    id = doc.data()['id'];
    timestamp = doc.data()['timestamp'];
    publicationOrderId = doc.data()['publication_order_id'];
    userId = doc.data()['user_id'];
    storeId = doc.data()['store_id'];
    totalQuantity = doc.data()['total_quantity'];
    totalAmount = doc.data()['total_amount'];
    receiveStoreName = doc.data()['receive_store_name'];
    receiveTime = doc.data()['receive_time'];
    receiveMethodName = doc.data()['receive_method_name'];
    receiveMethodOrderMessage = doc.data()['receive_method_order_message'];
    paymentMethodName = doc.data()['payment_method_name'];
    isReceived = doc.data()['is_received'];
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
        'timestamp': timestamp,
        'publication_order_id': publicationOrderId,
        'user_id': userId,
        'store_id': storeId,
        'products': products.map((product) => product.toJson()).toList(),
        'total_quantity': totalQuantity,
        'total_amount': totalAmount,
        'receive_store_name': receiveStoreName,
        'receive_time': receiveTime,
        'receive_method_name': receiveMethodName,
        'receive_method_order_message': receiveMethodOrderMessage,
        'payment_method_name': paymentMethodName,
        'is_received': isReceived,
      };
}
