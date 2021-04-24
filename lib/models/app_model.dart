import 'dart:convert';
import 'dart:math' as math;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pre_order_flutter_app/api/request/publish_order_request.dart';
import 'package:pre_order_flutter_app/entities/account.dart';
import 'package:pre_order_flutter_app/entities/cart.dart';
import 'package:pre_order_flutter_app/entities/order.dart';
import 'package:pre_order_flutter_app/entities/payment_method.dart';
import 'package:pre_order_flutter_app/entities/product.dart';
import 'package:pre_order_flutter_app/entities/product_category.dart';
import 'package:pre_order_flutter_app/entities/receive_method.dart';
import 'package:pre_order_flutter_app/entities/store.dart';
import 'package:pre_order_flutter_app/screens/auth_layer/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AppModel with ChangeNotifier {
  List<Account> accountList;
  List<Store> storeList;
  List<Product> productList;
  List<Order> orderList;
  List<ProductCategory> productCategoryList;
  List<Cart> cartList;
  List<ReceiveMethod> receiveMethodList;
  List<PaymentMethod> paymentMethodList;

  String accountUuid;
  Account myAccount;
  double latitude;
  double longitude;
  int orderId;
  String publicationOrderId;
  Cart myCart;
  Order myOrder;
  Store selectedStore;
  Product selectedProduct;
  String selectedReceiveTime;
  ReceiveMethod selectedReceiveMethod;
  PaymentMethod selectedPaymentMethod;
  int productCounter;
  List<Product> searchedProductList;
  int topScreenTabIndex = 0;

  void updateTopScreenTabIndex(int index) {
    topScreenTabIndex = index;
    notifyListeners();
  }

  void updateSelectedProduct(product) {
    selectedProduct = product;
    notifyListeners();
  }

  void selectReceiveTime(String receiveTime) {
    selectedReceiveTime = receiveTime;
    notifyListeners();
  }

  void selectReceiveMethod(ReceiveMethod receiveMethod) {
    selectedReceiveMethod = receiveMethod;
    notifyListeners();
  }

  void selectPaymentMethod(PaymentMethod paymentMethod) {
    selectedPaymentMethod = paymentMethod;
    notifyListeners();
  }

  void resetProductCounter() {
    productCounter = 1;
    notifyListeners();
  }

  void incrementProductCounter() {
    productCounter++;
    notifyListeners();
  }

  void decrementProductCounter() {
    if (productCounter > 0) {
      productCounter--;
    }
    notifyListeners();
  }

  void startOrder(Store store) async {
    selectedStore = store;
    orderId = 0;
    while (orderId < 10000) {
      orderId = math.Random().nextInt(100000000);
    }
    publicationOrderId = Uuid().v4();
    productCounter = 1;
    searchedProductList = productList;
    selectedReceiveTime = null;
    selectedReceiveMethod = null;
    selectedPaymentMethod = null;
    await allDeleteMyCart();
    await entryCart();
  }

  void selectedOrderOptionInit() {
    selectedReceiveTime = null;
    selectedReceiveMethod = null;
    selectedPaymentMethod = null;
  }

  void getAccountList() {
    final snapshots =
        FirebaseFirestore.instance.collection('accounts').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      accountList = docs.map((doc) => Account(doc)).toList();
      notifyListeners();
    });
  }

  void getStoreList() {
    final snapshots =
        FirebaseFirestore.instance.collection('stores').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      storeList = docs.map((doc) => Store(doc)).toList();
      sortStoreListByDistance(latitude, longitude);
      notifyListeners();
    });
  }

  void sortStoreListByDistance(double latitude, double longitude) {
    if (latitude == null) {
      return;
    }
    if (longitude == null) {
      return;
    }
    if (storeList == null) {
      return;
    }
    storeList.forEach((store) {
      store.distance = distanceBetween(
        latitude,
        longitude,
        store.latitude,
        store.longitude,
      );
    });
    storeList.sort((a, b) => a.distance.toInt() - b.distance.toInt());
  }

  void getProductCategoryList() {
    final snapshots =
        FirebaseFirestore.instance.collection('product_categories').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      productCategoryList = docs.map((doc) => ProductCategory(doc)).toList();
      notifyListeners();
    });
  }

  void getProductList() {
    final snapshots =
        FirebaseFirestore.instance.collection('products').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      productList = docs.map((doc) => Product(doc)).toList();
      notifyListeners();
    });
  }

  void getCartList() {
    final snapshots =
        FirebaseFirestore.instance.collection('carts').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      cartList = docs.map((doc) => Cart(doc)).toList();
      notifyListeners();
    });
  }

  void getOrderList() {
    final snapshots =
        FirebaseFirestore.instance.collection('orders').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      orderList = docs.map((doc) => Order(doc)).toList();
      orderList.sort((a, b) => b.receiveTime.compareTo(a.receiveTime));
      notifyListeners();
    });
  }

  void getPaymentMethodList() {
    final snapshots =
        FirebaseFirestore.instance.collection('payment_methods').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      paymentMethodList = docs.map((doc) => PaymentMethod(doc)).toList();
      notifyListeners();
    });
  }

  void getReceiveMethodList() {
    final snapshots =
        FirebaseFirestore.instance.collection('receive_methods').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      receiveMethodList = docs.map((doc) => ReceiveMethod(doc)).toList();
      notifyListeners();
    });
  }

  Future entryCart() async {
    final collection = FirebaseFirestore.instance.collection('carts');
    await collection
        .add({
          'id': orderId,
          'publication_order_id': publicationOrderId,
          'user_id': myAccount.id,
          'store_id': selectedStore.id,
          'products': [],
          'total_quantity': 0,
          'total_amount': 0,
        })
        .then((value) => print('$value'))
        .catchError((error) => print('Failed to add user: $error'));
    await fetchMyCart();
    notifyListeners();
  }

  Future fetchMyCart() async {
    final collection =
        await FirebaseFirestore.instance.collection('carts').get();
    myCart = collection.docs
        .map((doc) => Cart(doc))
        .toList()
        .firstWhere((cart) => cart.id == orderId, orElse: () => null);
    print('myCart: ${myCart?.id.toString() ?? ''}');
    notifyListeners();
  }

  Future allDeleteMyCart() async {
    if (cartList == null) {
      return;
    }
    final myCarts =
        cartList.where((cart) => cart.userId == myAccount.id).toList();
    final references = myCarts.map((cart) => cart.documentReference).toList();
    final batch = FirebaseFirestore.instance.batch();
    references.forEach((reference) {
      batch.delete(reference);
    });
    return batch.commit();
  }

  Future addProductToCart(Product product, int count) async {
    // FIXME: 暫定処理
    product.count = 1;
    for (var i = 0; i < count; i++) {
      myCart.products.add(product);
    }
    await updateCart();
  }

  Future updateCart() async {
    await arrangeCart();
    final document = FirebaseFirestore.instance
        .collection('carts')
        .doc(myCart.documentReference.id);
    await document.update(myCart.toJson());
  }

  Future arrangeCart() async {
    // FIXME: もっと綺麗に書けるはず
    final myCartproductIdList =
        myCart.products.map((product) => product.id).toSet().toList();
    var tmpMyCartproductList = <Product>[];
    myCartproductIdList.forEach((productId) {
      final productCount = myCart.products
          .where((product) => product.id == productId)
          .toList()
          .fold(0, (int sum, Product product) => sum + (product.count ?? 1));
      final targetProduct =
          productList.firstWhere((product) => product.id == productId);
      targetProduct.count = productCount;
      tmpMyCartproductList.add(targetProduct);
    });
    myCart.products = tmpMyCartproductList;
    myCart.products.removeWhere((product) => (product.count ?? 0) < 1);
    final totalQuantity = myCart.products
        .fold(0, (int sum, Product product) => sum + product.count);
    final totalAmount = myCart.products.fold(
        0, (int sum, Product product) => sum + (product.price * product.count));
    myCart.totalAmount = totalAmount;
    myCart.totalQuantity = totalQuantity;
  }

  Future incrementProductToCart(int productId) async {
    myCart.products
        .where((product) => product.id == productId)
        .map((product) => product.count++)
        .toList();
    await updateCart();
  }

  Future decrementProductToCart(int productId) async {
    myCart.products
        .where((product) => product.id == productId)
        .toList()
        .map((product) => product.count--)
        .toList();
    await updateCart();
  }

  Future orderConfirm() async {
    final collection = FirebaseFirestore.instance.collection('orders');
    await collection
        .add({
          'id': orderId,
          'publication_order_id':
              '${selectedReceiveMethod.initial}-${orderId.toString().substring(0, 4)}',
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'user_id': myCart.userId,
          'store_id': myCart.storeId,
          'products':
              myCart.products.map((product) => product.toJson()).toList(),
          'total_quantity': myCart.totalQuantity,
          'total_amount': myCart.totalAmount,
          'receive_store_name': selectedStore.name,
          'receive_time':
              '${DateFormat('yyyy/M/d(E)').format(DateTime.now())} $selectedReceiveTime',
          'receive_method_name': selectedReceiveMethod.name,
          'receive_method_order_message': selectedReceiveMethod.orderMessage,
          'payment_method_name': selectedPaymentMethod.name,
          'is_received': false,
        })
        .then((value) => print('$value'))
        .catchError((error) => print('Failed to add user: $error'));

    final publishOrderRequest = PublishOrderRequest(
      timestamp: DateTime.now().toUtc().toIso8601String(),
      customerId: myCart.userId,
      storeId: myCart.storeId,
      orderId: orderId,
      totalAmount: myCart.totalAmount,
      products: myCart.products.map((product) => product.id).toSet().toList(),
      deliveryMethod: selectedReceiveMethod.name,
      paymentMethod: selectedPaymentMethod.name,
      lat: latitude,
      lon: longitude,
    );
    await publishOrder(publishOrderRequest);
    notifyListeners();
  }

  Future doneReceived(Order order) async {
    order.isReceived = true;
    final document = FirebaseFirestore.instance
        .collection('orders')
        .doc(order.documentReference.id);
    await document.update(order.toJson());
  }

  void onChange(String text) {
    if (text != null && text != '') {
      searchedProductList = [];
      searchedProductList
          .addAll(productList.where((product) => product.name.contains(text)));
    } else {
      searchedProductList = productList;
    }
    notifyListeners();
  }

  Future publishOrder(PublishOrderRequest request) async {
    var url = Uri.parse(
        'https://showroombff.showroom2021ifrcluster-db4741880439d7b64a494a9a83d1b4a4-0000.sjc03.containers.appdomain.cloud/api/v1/admin/publish');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-SHOWROOM-KEY': '5fd4fb00-1b51-442c-9a9f-604c5f13a70c',
      },
      body: json.encode(request.toJson()),
    );
    if (response.statusCode == 200) {
      print(json.encode(request.toJson()));
      print(response.body);
    } else {
      print(json.encode(request.toJson()));
      print(response);
    }
  }

  double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    var earthRadius = 6378137.0;
    var dLat = _toRadians(endLatitude - startLatitude);
    var dLon = _toRadians(endLongitude - startLongitude);

    var a = pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) *
            cos(_toRadians(startLatitude)) *
            cos(_toRadians(endLatitude));
    var c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

  Future getMyAccount() async {
    print('call : getMyAccount');
    var pref = await SharedPreferences.getInstance();
    var accountUuid = pref.getString('accountUuid');
    this.accountUuid = accountUuid;
    if (accountList != null) {
      myAccount = accountList.firstWhere(
        (account) => account.uuid == this.accountUuid,
        orElse: () => null,
      );
      print('myAccount: ${myAccount.uuid}');
    }
    notifyListeners();
  }

  Future getMyOrder() async {
    if (myAccount != null && orderList != null) {
      orderList.sort((a, b) => b.receiveTime.compareTo(a.receiveTime));
      myOrder = orderList.firstWhere((order) => order.id == orderId,
          orElse: () => null);
      print('myOrder: ${myOrder?.id.toString() ?? ''}');
    }
    notifyListeners();
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    LoginModel.removePref();
  }
}
