import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pre_order_flutter_app/main.dart';
import 'package:provider/provider.dart';

class SingUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SingUpModel>(builder: (context, model, child) {
      final isHidePassword = model.isHidePassword ?? true;
      final canSingUp = model.userName != null &&
          model.emailAddress != null &&
          model.password != null;
      final errorMsg = model.errorMsg ?? '';
      return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Image.asset(
                'assets/images/showroom_logo.png',
                height: 16,
                width: 97,
              ),
              Text('新規登録'),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 30,
              bottom: 60,
              left: 30,
              right: 30,
            ),
            child: Center(
              child: Column(
                children: <Widget>[
                  Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'User Name',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                          ),
                          TextField(
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.account_circle),
                              hintText: 'User Name',
                            ),
                            onChanged: model.onChangeUserName,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 30),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                          ),
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail_outline),
                              hintText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: model.onChangeEmailAddress,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 30),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.vpn_key),
                              suffixIcon: IconButton(
                                icon: isHidePassword
                                    ? Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.green,
                                      )
                                    : Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                onPressed: () {
                                  model
                                      .updateHidePasswordState(!isHidePassword);
                                },
                              ),
                              hintText: 'Password',
                            ),
                            obscureText: isHidePassword,
                            keyboardType: TextInputType.visiblePassword,
                            onChanged: model.onChangePassword,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 30),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: !canSingUp
                              ? null
                              : () async {
                                  try {
                                    await model.singUp();
                                    await analytics.logSignUp(
                                      signUpMethod: 'email_password',
                                    );
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('メールアドレス確認用のメールを送信しました'),
                                          content: Text(
                                              'メールをご確認いただき、メールに記載された URL をクリックして登録の完了を行ってください。'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              style: TextButton.styleFrom(
                                                primary: Colors.blueAccent,
                                              ),
                                              child: Text(
                                                'OK',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    Navigator.of(context).pop();
                                  } on FirebaseAuthException catch (e) {
                                    model.updateErrorMsg(e.message);
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                          child: Text(
                            '登録する',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                      ),
                      Text(
                        '$errorMsg',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class SingUpModel with ChangeNotifier {
  bool isHidePassword;
  bool canSingUp;
  String userName;
  String emailAddress;
  String password;
  String errorMsg;
  final auth = FirebaseAuth.instance;

  void updateHidePasswordState(bool state) {
    isHidePassword = state;
    notifyListeners();
  }

  void onChangeUserName(String text) {
    userName = text;
    notifyListeners();
  }

  void onChangeEmailAddress(String text) {
    emailAddress = text;
    notifyListeners();
  }

  void onChangePassword(String text) {
    password = text;
    notifyListeners();
  }

  Future singUp() async {
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    final user = auth.currentUser;
    if (!user.emailVerified) {
      await user.sendEmailVerification();
    }
    await addAccount(userCredential.user.uid);
  }

  void updateErrorMsg(String msg) {
    errorMsg = msg;
    notifyListeners();
  }

  Future addAccount(String uuid) async {
    // TODO: ここは適当なので修正する
    var id = 0;
    while (id < 10000) {
      id = math.Random().nextInt(100000000);
    }

    final collection = FirebaseFirestore.instance.collection('accounts');
    await collection
        .add({
          'id': id,
          'name': userName,
          'uuid': uuid,
          'emailAddress': emailAddress,
        })
        .then((value) => print('$value'))
        .catchError((error) => print('Failed to add user: $error'));
    notifyListeners();
  }
}
