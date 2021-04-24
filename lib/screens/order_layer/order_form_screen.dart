import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pre_order_flutter_app/entities/payment_method.dart';
import 'package:pre_order_flutter_app/entities/receive_method.dart';
import 'package:pre_order_flutter_app/main.dart';
import 'package:pre_order_flutter_app/models/app_model.dart';
import 'package:pre_order_flutter_app/screens/order_layer/order_confirmation_screen.dart';
import 'package:provider/provider.dart';

enum SingingCharacter { lafayette, jefferson }

class OrderFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Image.asset(
                'assets/images/showroom_logo.png',
                height: 16,
                width: 97,
              ),
              Text('注文の確定'),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            children: <Widget>[
              StoreCrowdStateView(),
              ReceiveTimeSelectView(),
              ReceiveMethodSelectView(),
              PaymentMethodSelectView(),
              CartTotalView(),
              CartDetailView(),
              SizedBox(
                height: 120,
              ),
            ],
          ),
        ),
        bottomSheet: BottomAppBar(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 30,
              left: 35,
              right: 35,
            ),
            child: OrderConfirmButtonView(),
          ),
        ),
      );
    });
  }
}

class StoreCrowdStateView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (_, model, __) {
      return Padding(
        padding: EdgeInsets.only(top: 30, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '混雑傾向',
              style: TextStyle(fontSize: 20),
            ),
            Container(
              height: 200,
              width: double.infinity,
              child: Card(
                elevation: 5,
                child: Image.asset(
                  'assets/images/crowd_state_graph.png',
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class ReceiveTimeSelectView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (_, model, __) {
      final now = DateTime.now();
      final mm = DateFormat('mm');
      final HHmm = DateFormat('HH:mm');
      var standardDate = int.parse(mm.format(now)) < 30
          ? DateTime(now.year, now.month, now.day, now.hour + 1)
          : DateTime(now.year, now.month, now.day, now.hour, 30);
      final HHmmTimePickerItems = [
        standardDate,
        standardDate.add(Duration(minutes: 30)),
        standardDate.add(Duration(minutes: 60)),
        standardDate.add(Duration(minutes: 90)),
        standardDate.add(Duration(minutes: 120)),
      ].map((dateTime) => HHmm.format(dateTime)).toList();
      return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '受け取り時間',
              style: TextStyle(fontSize: 20),
            ),
            DropdownButton<String>(
              hint: Text(
                '選択してください',
              ),
              underline: Container(
                height: 1,
                color: Colors.grey,
              ),
              value: model.selectedReceiveTime,
              onChanged: (String newValue) {
                model.selectReceiveTime(newValue);
              },
              items: HHmmTimePickerItems.map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                },
              ).toList(),
            )
          ],
        ),
      );
    });
  }
}

class ReceiveMethodSelectView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (_, model, __) {
      final receiveMethodList = model.receiveMethodList;
      final receiveMethodRadioListTile = receiveMethodList
          .map(
            (receiveMethod) => RadioListTile<ReceiveMethod>(
              title: Text(
                receiveMethod.name,
                style: TextStyle(fontSize: 16),
              ),
              value: receiveMethod,
              groupValue: model.selectedReceiveMethod,
              onChanged: (ReceiveMethod value) {
                model.selectReceiveMethod(value);
              },
            ),
          )
          .toList();
      return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '受け取り方法',
              style: TextStyle(fontSize: 20),
            ),
            Column(
              children: receiveMethodRadioListTile,
            )
          ],
        ),
      );
    });
  }
}

class PaymentMethodSelectView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (_, model, __) {
      final paymentMethodList = model.paymentMethodList;
      final paymentMethodRadioListTile = paymentMethodList
          .map(
            (paymentMethod) => RadioListTile<PaymentMethod>(
              title: Text(
                paymentMethod.name,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              value: paymentMethod,
              groupValue: model.selectedPaymentMethod,
              onChanged: (PaymentMethod value) {
                model.selectPaymentMethod(value);
              },
            ),
          )
          .toList();
      return Padding(
        padding: EdgeInsets.only(
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '決済方法',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Column(
              children: paymentMethodRadioListTile,
            )
          ],
        ),
      );
    });
  }
}

class CartTotalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (_, model, __) {
      final myCart = model.myCart;
      return Padding(
        padding: EdgeInsets.only(
          bottom: 20,
        ),
        child: Row(
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
      );
    });
  }
}

class CartDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (_, model, __) {
      final productItems = model.myCart.products
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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'カート内の商品',
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
      );
    });
  }
}

class OrderConfirmButtonView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (_, model, __) {
      var canOrderConfirm = model.selectedReceiveTime != null &&
          model.selectedReceiveMethod != null &&
          model.selectedPaymentMethod != null;
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: !canOrderConfirm
              ? null
              : () async {
                  await model.orderConfirm();
                  await model.getMyOrder();
                  await analytics.logEcommercePurchase(
                    transactionId: model.orderId.toString(),
                  );
                  await Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          OrderConfirmationScreen(),
                    ),
                    (route) => false,
                  );
                },
          child: Text(
            '注文を確定する',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      );
    });
  }
}
