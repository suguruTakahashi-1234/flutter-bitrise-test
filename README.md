# pre_order_flutter_app

[![Codemagic build status](https://api.codemagic.io/apps/6098b499f3dcf2b4763b420c/6098b499f3dcf2b4763b420b/status_badge.svg)](https://codemagic.io/apps/6098b499f3dcf2b4763b420c/6098b499f3dcf2b4763b420b/latest_build)

## 注意点

- Codemagic との連携は現在 OFF にしているので、CI/CDは動きません。
そのため、アップデートしたアプリを配布したい場合は「Build to Firebase App Distribution」の記載の手順で Firebase App Distribution から配布してください。ただし、それを行うためには Firebase への接続のための鍵ファイルとアプリ署名のための鍵ファイルが必要になるので高橋までご連絡ください。（このように運用に属人的にならないためにも Codemagic などでの CI/CD の仕組みづくりは大事。）
- Firebase アカウントは高橋個人のものを使用しております。予告なくアプリが使用できなくなる可能性があるのでご了承ください。また、従量課金の設定なので優しく使っていただけると幸いです。

## アプリのダウンロード方法

【テストユーザー情報】  
用途：共有の App Distribution で配信されたテストアプリのダウンロード  
端末条件：iOS 14.4以上の端末、Android11以上の端末  

■iOS  
iOSアカウント：iseshopuser@gmail.com  
iOSアカウントパスワード：ise20212021  
iOSアクティベートリンク：https://appdistribution.firebase.dev/i/38515203481b7a05  

■Android  
Androidアカウント：isetaroand@gmail.com  
Androidアカウントパスワード：ise20212021  
Androidアクティベートリンク：https://appdistribution.firebase.dev/i/a8d4afe85f96f762  

■大まかなダウンロード方法  
App Testerアプリのダウンロード→対象のアプリのダウンロードという手順です。
1. iPhone or Android 端末からアクティベートリンクにアクセスする
2. iOS なら iOS アカウント、Android なら Android アカウントの上記記載されているメールアドレス/パスワードを入力する
3. Gmail にログインする（共有アカウントを使用しているため、もしかすると二要素認証に引っかかって誰かにアクティベートしてもらわないとログインできない可能性があります。）
4. 最新（おそらく）のメールの中央部に「Install Firebase App Tester」とあるので、そこから「App Tester」アプリをダウンロードする（※ここで Download the latest build をタップしても App Tester のアプリがないためダウンロードできない）
5. App Tester を立ち上げると Google のログインが求められるので、そこでは先程ログインしたアカウントでログインする（※個人のアカウントは使用しない）
6. 画面の指示通りに操作していくと App Tester にダンロードできるアプリの一覧が出てくるので、1番上のアプリ（最新のアプリ）をダウンロードする
7. ダウンロードに成功するとホーム画面にインストールしたアプリが表示されるので、それを起動するとアプリが操作できる

■手順の参考となるリンク  
※条件が異なるため全く同じ手順ではありません  

【iOS参考】[iOS] Firebase App Distributionを使用してiOSアプリを配布する  
https://dev.classmethod.jp/articles/ios-firebase-distribution/  

【Android参考】Firebase App DistributionでAndroidアプリをダウンロードする方法  
https://pentagon.tokyo/app/2312/  

## Architecture

![](./reference/architecture.drawio.svg)

## CI/CD

![](./reference/cicd.drawio.svg)

## Requirements

- Flutter: 2.0.6
- Dart: 2.12.3
- Xcode: 12.5
- Android Studio: 4.2

```shell
$ flutter --version
Flutter 2.0.6 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 1d9032c7e1 (12 days ago) • 2021-04-29 17:37:58 -0700
Engine • revision 05e680e202
Tools • Dart 2.12.3

$ sw_vers
ProductName:	macOS
ProductVersion:	11.3.1
BuildVersion:	20E241

$ xcodebuild -version
Xcode 12.5
Build version 12E262

$ flutter doctor -v
[✓] Flutter (Channel stable, 2.0.6, on macOS 11.3.1 20E241 darwin-x64, locale ja-JP)
    • Flutter version 2.0.6 at /Users/sugurutakahashi/development/flutter
    • Framework revision 1d9032c7e1 (12 days ago), 2021-04-29 17:37:58 -0700
    • Engine revision 05e680e202
    • Dart version 2.12.3

[✓] Android toolchain - develop for Android devices (Android SDK version 29.0.3)
    • Android SDK at /Users/sugurutakahashi/Library/Android/sdk
    • Platform android-30, build-tools 29.0.3
    • Java binary at: /Applications/Android Studio.app/Contents/jre/jdk/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 11.0.8+10-b944.6916264)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Xcode 12.5, Build version 12E262
    • CocoaPods version 1.10.1

[✓] Chrome - develop for the web
    • Chrome at /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

[✓] Android Studio (version 4.2)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Flutter plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build 11.0.8+10-b944.6916264)

[✓] VS Code (version 1.56.1)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.22.0

[✓] Connected device (1 available)
    • Chrome (web) • chrome • web-javascript • Google Chrome 90.0.4430.212

• No issues found!
```

### Build to Firebase App Distribution

#### Android:

```shell
$ cd android
$ fastlane distribute
```

#### iOS:

```shell
$ cd ios
$ fastlane distribute
```

### build to TestFlight

#### iOS:

```shell
$ cd ios
$ fastlane beta
```


### Enabling debug mode Local (Firebase Analitycis)

#### Android:

To enable Analytics Debug mode on an Android device, execute the following commands:

```shell
$ adb shell setprop debug.firebase.analytics.app ise.sr.u2021.pre_order_flutter_app
```

This behavior persists until you explicitly disable Debug mode by executing the following command:

```shell
$ adb shell setprop debug.firebase.analytics.app .none.
```

#### iOS:

Settings: Xcode > Product > Scheme > Edit Scheme > Run > Aguments

**Run Build in Xcode!!**

To enable Analytics Debug mode on your development device, specify the following command line argument in Xcode :

```
-FIRDebugEnabled
```

This behavior persists until you explicitly disable Debug mode by specifying the following command line argument :

```
-FIRDebugDisabled
```
