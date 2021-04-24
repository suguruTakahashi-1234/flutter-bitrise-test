import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pre_order_flutter_app/main.dart';
import 'package:pre_order_flutter_app/models/app_model.dart';
import 'package:pre_order_flutter_app/screens/auth_layer/sign_up_screen.dart';
import 'package:pre_order_flutter_app/screens/top_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginModel>(builder: (context, model, child) {
      final isHidePassword = model.isHidePassword ?? true;
      final canSingUp = model.emailAddress != null && model.password != null;
      final errorMsg = model.errorMsg ?? '';
      return Scaffold(
        body: Container(
          color: Color(0xFF1853B5),
          child: Center(
            child: SizedBox(
              height: 480,
              width: 300,
              child: Card(
                elevation: 20,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                    ),
                    Image.asset(
                      'assets/images/showroom_logo_bk.png',
                      height: 32,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                    ),
                    Text(
                      'Shopping App',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 24),
                    ),
                    SizedBox(
                      width: 260,
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail_outline),
                          hintText: 'Email',
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: model.onChangeEmailAddress,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                    ),
                    SizedBox(
                      width: 260,
                      child: TextField(
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
                              model.updateHidePasswordState(!isHidePassword);
                            },
                          ),
                          hintText: 'Password',
                          labelText: 'Password',
                        ),
                        obscureText: isHidePassword,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: model.onChangePassword,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                    ),
                    SizedBox(
                      height: 40,
                      width: 220,
                      child: Consumer<AppModel>(
                          builder: (context, appModel, child) {
                        return ElevatedButton(
                          onPressed: !canSingUp
                              ? null
                              : () async {
                                  try {
                                    await model.signInWithEmailAndPassword();
                                    await Fluttertoast.showToast(
                                      msg: 'ログインに成功しました',
                                      fontSize: 20.0,
                                    );
                                    model.clearTextField();
                                    await appModel.getMyAccount();
                                    await analytics.logLogin(
                                      loginMethod: 'Email Password',
                                    );
                                    await Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            TopScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  } on FirebaseAuthException catch (e) {
                                    model.updateErrorMsg(e.message);
                                  } catch (e) {
                                    model.updateErrorMsg('${e.toString()}');
                                  }
                                },
                          child: Text(
                            'ログイン',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        '$errorMsg',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                    ),
                    Divider(
                      indent: 10,
                      endIndent: 10,
                      thickness: 2,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                    ),
                    Consumer<AppModel>(builder: (context, appModel, child) {
                      return SignInButton(
                        Buttons.Google,
                        onPressed: () async {
                          try {
                            await model.signInWithGoogle();
                            await Fluttertoast.showToast(
                              msg: 'ログインに成功しました',
                              fontSize: 20.0,
                            );
                            model.clearTextField();
                            await appModel.getMyAccount();
                            await analytics.logLogin(
                              loginMethod: 'Google',
                            );
                            await Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => TopScreen(),
                              ),
                              (route) => false,
                            );
                          } on FirebaseAuthException catch (e) {
                            model.updateErrorMsg(e.code);
                          } on Exception catch (e) {
                            model.updateErrorMsg('${e.toString()}');
                          }
                        },
                      );
                    }),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingUpScreen(),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      child: Text(
                        'ユーザー登録',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class LoginModel with ChangeNotifier {
  bool isHidePassword;
  bool canLogin;
  String emailAddress;
  String password;
  String errorMsg;
  final auth = FirebaseAuth.instance;

  void updateHidePasswordState(bool state) {
    isHidePassword = state;
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

  Future authStateChangesListen() async {
    auth.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  Future signInWithGoogle() async {
    final googleSignInAccount = await GoogleSignIn(scopes: [
      'email',
    ]).signIn();
    final googleSignInAuthentication = await googleSignInAccount.authentication;
    final authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final authResult = await auth.signInWithCredential(authCredential);
    print(authResult.user.uid);
    final isExistedGoogleAccountUuid =
        await existGoogleAccountUuid(authResult.user.uid);
    await saveAccountUuid(authResult.user.uid);
    if (!isExistedGoogleAccountUuid) {
      await addGoogleAccount(authResult.user.uid);
    }
  }

  Future signInWithEmailAndPassword() async {
    updateErrorMsg('');
    var userCredential = await auth.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    print(userCredential.user.uid);
    await saveAccountUuid(userCredential.user.uid);
  }

  void updateErrorMsg(String msg) {
    errorMsg = msg;
    notifyListeners();
  }

  Future saveAccountUuid(String uuid) async {
    var pref = await SharedPreferences.getInstance();
    await pref.setString('accountUuid', uuid);
    print('save: $uuid');
  }

  Future addGoogleAccount(String uuid) async {
    // TODO: ここは適当なので修正する
    var id = 0;
    while (id < 10000) {
      id = math.Random().nextInt(100000000);
    }

    final collection = FirebaseFirestore.instance.collection('accounts');
    await collection
        .add({
          'id': id,
          'uuid': uuid,
        })
        .then((value) => print('$value'))
        .catchError((error) => print('Failed to add user: $error'));
    notifyListeners();
  }

  Future<bool> existGoogleAccountUuid(String uuid) async {
    return await FirebaseFirestore.instance
        .collection('accounts')
        .where('uuid', isEqualTo: uuid)
        .get()
        .then(
      (account) {
        return account.docs.isNotEmpty;
      },
    );
  }

  static Future removePref() async {
    var pref = await SharedPreferences.getInstance();
    await pref.remove('accountUuid');
    print('remove uuid');
  }

  void clearTextField() {
    emailAddress = null;
    password = null;
  }
}
