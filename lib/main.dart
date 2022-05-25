import 'package:infoklinik/view/login.dart';
import 'package:flutter/material.dart';
import 'package:infoklinik/constant/constant.dart';
import 'package:infoklinik/launcher.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // OneSignal.shared
  //     .init("XXXXXXXXX", iOSSettings: null);
  // OneSignal.shared
  //     .setInFocusDisplayType(OSNotificationDisplayType.notification);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Buku Kuangan Digital",
    home: Launcher(),
    theme: ThemeData(primaryColor: Colors.green),
    routes: <String, WidgetBuilder>{
      SPLASH_SCREEN: (BuildContext context) => Launcher(),
      HOME_SCREEN: (BuildContext context) => Login(),
    },
  ));
}
