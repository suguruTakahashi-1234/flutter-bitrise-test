import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pre_order_flutter_app/common/analytics.dart';
import 'package:pre_order_flutter_app/models/app_model.dart';
import 'package:pre_order_flutter_app/screens/auth_layer/login_screen.dart';
import 'package:pre_order_flutter_app/screens/top_layer/order_list_screen.dart';
import 'package:pre_order_flutter_app/screens/top_layer/selete_store_screen.dart';
import 'package:provider/provider.dart';

class TopScreenTab {
  String title;
  Widget widget;

  TopScreenTab(this.title, this.widget);
}

class TopScreen extends StatelessWidget {
  final List<TopScreenTab> _tabs = [
    TopScreenTab('店舗を選ぶ', SelectStoreScreen()),
    TopScreenTab('注文を確認する', OrderListScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (_, model, __) {
      final initialIndex = model.topScreenTabIndex;
      return DefaultTabController(
        length: _tabs.length,
        initialIndex: initialIndex,
        child: Scaffold(
          appBar: AppBar(
            title: Column(
              children: [
                Image.asset(
                  'assets/images/showroom_logo.png',
                  height: 16,
                  width: 97,
                ),
                Text('Shopping'),
              ],
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('ログアウトしますか？'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Analytics.analyticsLogEvent(
                                  AnalyticsEventType.logout,
                                  null,
                                );
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(),
                              child: Text(
                                'キャンセル',
                                style: TextStyle(),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                model.updateTopScreenTabIndex(0);
                                await model.logout();
                                await Fluttertoast.showToast(
                                  msg: 'ログアウトしました',
                                  fontSize: 20.0,
                                );
                                await Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              style: TextButton.styleFrom(
                                primary: Colors.redAccent,
                              ),
                              child: Text(
                                'ログアウトする',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
            bottom: TabBar(
              tabs: _tabs.map(
                (TopScreenTab tab) {
                  return Tab(text: tab.title);
                },
              ).toList(),
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: _tabs.map((tab) => tab.widget).toList(),
          ),
        ),
      );
    });
  }
}
