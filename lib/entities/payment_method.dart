import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethod {
  int id;
  String name;

  PaymentMethod(DocumentSnapshot doc) {
    id = doc.data()['id'];
    name = doc.data()['name'];
  }
}
