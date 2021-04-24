import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pre_order_flutter_app/main.dart';
import 'package:pre_order_flutter_app/models/app_model.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (_, model, __) {
      final product = model.selectedProduct;
      final isInMyCart = model.myCart.products.contains(model.selectedProduct);
      return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Image.asset(
                'assets/images/showroom_logo.png',
                height: 16,
                width: 97,
              ),
              Text('商品詳細'),
            ],
          ),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.only(top: 45, left: 30, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: 270,
                      padding: EdgeInsets.only(bottom: 30),
                      child: Image.network(product.imageUrl),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            '¥ ${product.price}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                isInMyCart
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'カートの個数を変更する',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      model.decrementProductToCart(product.id);
                                      analytics.logAddToCart(
                                        itemId: product.id.toString(),
                                        itemName: product.name,
                                        itemCategory:
                                            product.categoryId.toString(),
                                        quantity: 1,
                                      );
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          CircleBorder>(CircleBorder()),
                                      elevation:
                                          MaterialStateProperty.all<double>(
                                              4.0),
                                    ),
                                    child: Icon(Icons.remove),
                                  ),
                                  Text(
                                    '${product.count} 点',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      model.incrementProductToCart(product.id);
                                      analytics.logRemoveFromCart(
                                        itemId: product.id.toString(),
                                        itemName: product.name,
                                        itemCategory:
                                            product.categoryId.toString(),
                                        quantity: 1,
                                      );
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          CircleBorder>(CircleBorder()),
                                      elevation:
                                          MaterialStateProperty.all<double>(
                                              4.0),
                                    ),
                                    child: Icon(Icons.add),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '小計：',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    '¥ ${product.price * product.count}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      )
                    : Consumer<AppModel>(builder: (context, model, child) {
                        final count = model.productCounter;
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '小計：',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        '¥ ${product.price * count}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: count == 0
                                            ? null
                                            : () {
                                                model.decrementProductCounter();
                                              },
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              CircleBorder>(CircleBorder()),
                                          elevation:
                                              MaterialStateProperty.all<double>(
                                                  count == 0 ? 0.0 : 4.0),
                                        ),
                                        child: Icon(Icons.remove),
                                      ),
                                      Text(
                                        '$count 点',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          model.incrementProductCounter();
                                        },
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              CircleBorder>(CircleBorder()),
                                          elevation:
                                              MaterialStateProperty.all<double>(
                                                  4.0),
                                        ),
                                        child: Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: count == 0
                                    ? null
                                    : () {
                                        model.addProductToCart(
                                          product,
                                          count,
                                        );
                                        analytics.logAddToCart(
                                          itemId: product.id.toString(),
                                          itemName: product.name,
                                          itemCategory:
                                              product.categoryId.toString(),
                                          quantity: count,
                                        );
                                        Fluttertoast.showToast(
                                          msg: 'カートに追加しました',
                                          fontSize: 20.0,
                                        );
                                        Navigator.of(context).pop();
                                      },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Icon(Icons.add_shopping_cart),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 30),
                                      child: Text(
                                        'カートに追加する',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        );
                      }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
