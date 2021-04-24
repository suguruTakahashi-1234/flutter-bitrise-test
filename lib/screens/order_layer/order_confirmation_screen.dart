import 'package:flutter/material.dart';
import 'package:pre_order_flutter_app/models/app_model.dart';
import 'package:pre_order_flutter_app/screens/top_screen.dart';
import 'package:provider/provider.dart';

class OrderConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (context, model, child) {
      final order = model.myOrder;
      return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Image.asset(
                'assets/images/showroom_logo.png',
                height: 16,
                width: 97,
              ),
              Text('決済完了'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            top: 50,
            bottom: 50,
            left: 30,
            right: 30,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'Thanks !',
                  style: TextStyle(
                    fontSize: 40,
                    color: Color(0xFF1853B5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                          '${order?.receiveTime ?? ''}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${order?.receiveStoreName ?? ''}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '${order?.receiveMethodOrderMessage ?? ''}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '${order?.publicationOrderId ?? ''}',
                          style: TextStyle(
                            fontSize: 36,
                            color: Color(0xFF1853B5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
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
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  model.updateTopScreenTabIndex(1);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => TopScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: Text(
                  '注文を確認する',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
