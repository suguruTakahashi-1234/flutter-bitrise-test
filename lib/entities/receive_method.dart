import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiveMethod {
  int id;
  String name;
  String orderMessage;
  String initial;

  ReceiveMethod(DocumentSnapshot doc) {
    id = doc.data()['id'];
    name = doc.data()['name'];
    orderMessage = doc.data()['order_message'];
    initial = doc.data()['initial'];
  }
}
