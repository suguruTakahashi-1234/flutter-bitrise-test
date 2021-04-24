import 'package:flutter/material.dart';
import 'package:pre_order_flutter_app/models/app_model.dart';
import 'package:pre_order_flutter_app/screens/top_layer/order_detail_screen.dart';
import 'package:provider/provider.dart';

class OrderListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppModel>(
        builder: (context, model, child) {
          final orderList = model.orderList
                  .where((order) => order.userId == model.myAccount.id)
                  .toList() ??
              [];
          final listTiles = orderList
              .map(
                (order) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '${order.receiveMethodName}@${order.receiveStoreName}',
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '受け取り時刻：${order.receiveTime}',
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.paymentMethodName,
                            ),
                            Text(
                              '¥ ${order.totalAmount.toString()}',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailScreen(order),
                          ),
                        );
                      },
                      trailing: Icon(
                        order.isReceived
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked,
                        color:
                            order.isReceived ? Colors.blueAccent : Colors.grey,
                      ),
                    ),
                  ),
                ),
              )
              .toList();
          return Padding(
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 16,
              left: 12,
              right: 12,
            ),
            child: listTiles.isEmpty
                ? Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('注文がありません'),
                      ],
                    ),
                  )
                : ListView(
                    children: listTiles,
                  ),
          );
        },
      ),
    );
  }
}
