import 'package:flutter/material.dart';
import 'package:pre_order_flutter_app/main.dart';
import 'package:pre_order_flutter_app/models/app_model.dart';
import 'package:pre_order_flutter_app/screens/order_layer/order_form_screen.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (_, model, __) {
      final myCart = model.myCart;
      final productItems = model.myCart.products
          .map(
            (product) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                child: ListTile(
                  leading: Image.network(
                    product.imageUrl,
                    width: 40,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${product.name}'),
                          Text('¥ ${product.price}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  model.decrementProductToCart(product.id);
                                  analytics.logRemoveFromCart(
                                    itemId: product.id.toString(),
                                    itemName: product.name,
                                    itemCategory: product.categoryId.toString(),
                                    quantity: 1,
                                  );
                                },
                                style: ButtonStyle(
                                  shape:
                                      MaterialStateProperty.all<CircleBorder>(
                                          CircleBorder()),
                                  elevation:
                                      MaterialStateProperty.all<double>(4.0),
                                ),
                                child: Icon(Icons.remove),
                              ),
                              Text(
                                '${product.count} 点',
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  model.incrementProductToCart(product.id);
                                  analytics.logAddToCart(
                                    itemId: product.id.toString(),
                                    itemName: product.name,
                                    itemCategory: product.categoryId.toString(),
                                    quantity: 1,
                                  );
                                },
                                style: ButtonStyle(
                                  shape:
                                      MaterialStateProperty.all<CircleBorder>(
                                          CircleBorder()),
                                  elevation:
                                      MaterialStateProperty.all<double>(4.0),
                                ),
                                child: Icon(Icons.add),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '小計：',
                              ),
                              Text(
                                '¥ ${product.price * product.count}',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList();
      return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Image.asset(
                'assets/images/showroom_logo.png',
                height: 16,
                width: 97,
              ),
              Text('カート内の商品'),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.square(160.0),
            child: Container(
              color: Colors.white,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '合計',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${myCart.totalQuantity} 点      ',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '¥ ${myCart.totalAmount}',
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
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: myCart.totalQuantity == 0
                            ? null
                            : () {
                                model.selectedOrderOptionInit();
                                analytics.logBeginCheckout(
                                  transactionId: model.orderId.toString(),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderFormScreen(),
                                  ),
                                );
                              },
                        child: Text(
                          myCart.totalQuantity == 0 ? 'カートの中身が空です' : 'レジに進む',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: productItems,
          ),
        ),
      );
    });
  }
}
