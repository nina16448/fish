import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:fish/Login_Page.dart';
import 'package:fish/PassowrdLogin.dart';
import 'package:fish/FaceIDLogin.dart';
import 'package:fish/Captain_Home.dart';
import 'package:fish/time.dart';
import 'package:fish/fisherHome.dart';
import 'package:fish/class/Choose_Button.dart';
import 'package:fish/PersonnelManagement.dart';
import 'package:fish/database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:fish/firebase_options.dart';
import 'package:fish/locator.dart';
import 'package:fish/MyFaceLogin.dart';

void main() async {
  setupServices();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: _scaffoldKey,
      debugShowCheckedModeBanner: false, //讓debug那條不顯示
      title: 'fishermen\'s service management',
      theme: ThemeData(
          fontFamily: 'GenJyuu',
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.windows: SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.horizontal),
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.horizontal),
            TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.horizontal),
            TargetPlatform.macOS: SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.horizontal),
          })), //字體
      routes: {
        '/': (context) => const HomePage(), //首頁
        // '/FaceIDLogin': (context) => const FaceIDLogin(),
        '/FaceIDLogin': (context) => const MyFaceIDLogin(),
        '/Captain_Home': (context) => const Captain_Home(),
        '/time': (context) => const Timeout(),
        '/Management': (context) => const Management(),
        '/FisherHome': (context) => const FisherHome(),
      },
    );
  }
}
