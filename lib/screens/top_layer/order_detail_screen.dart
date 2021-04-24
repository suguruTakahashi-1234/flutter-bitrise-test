import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pre_order_flutter_app/entities/order.dart';
import 'package:pre_order_flutter_app/models/app_model.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;
  OrderDetailScreen(this.order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注文の詳細'),
      ),
      body: Consumer<AppModel>(builder: (_, model, __) {
        final productItems = order.products
            .map(
              (product) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 8,
                  left: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${product.name}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${product.count}点 × ¥ ${product.price}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList();
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    child: SizedBox(
                      height: 230,
                      width: double.infinity,
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Color(0xFF1853B5),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  '注文票',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            order.receiveTime,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${order.receiveStoreName}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${order.receiveMethodOrderMessage}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            order.publicationOrderId,
                            style: TextStyle(
                              fontSize: 36,
                              color: Color(0xFF1853B5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: order.isReceived
                          ? null
                          : () async {
                              await model.doneReceived(order);
                              await Fluttertoast.showToast(
                                msg: '受け取りが完了しました',
                                fontSize: 20.0,
                              );
                            },
                      child: Text(
                        order.isReceived ? '受け取り済み' : '受け取りを完了する',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'お支払い情報',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ' 合計',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        '${order.totalQuantity.toString()} 点',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '¥ ${order.totalAmount.toString()}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    '購入した商品',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Column(
                    children: productItems,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
