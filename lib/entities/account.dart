import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  int id;
  String name;
  int age;
  String gender;
  String uuid;

  Account(DocumentSnapshot doc) {
    id = doc.data()['id'];
    name = doc.data()['name'];
    age = doc.data()['age'];
    gender = doc.data()['gender'];
    uuid = doc.data()['uuid'];
  }
}
