import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:pre_order_flutter_app/common/theme.dart';
import 'package:pre_order_flutter_app/models/app_model.dart';
import 'package:pre_order_flutter_app/screens/auth_layer/login_screen.dart';
import 'package:pre_order_flutter_app/screens/auth_layer/sign_up_screen.dart';
import 'package:provider/provider.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  runZonedGuarded(
    () {
      runApp(MyApp());
    },
    FirebaseCrashlytics.instance.recordError,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppModel>(
          create: (context) => AppModel()
            ..getAccountList()
            ..getStoreList()
            ..getProductCategoryList()
            ..getProductList()
            ..getCartList()
            ..getOrderList()
            ..getPaymentMethodList()
            ..getReceiveMethodList(),
        ),
        ChangeNotifierProvider<SingUpModel>(
          create: (context) => SingUpModel(),
        ),
        ChangeNotifierProvider<LoginModel>(
          create: (context) => LoginModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: LoginScreen(),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
      ),
    );
  }
}
