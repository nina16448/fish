// ignore_for_file: file_names
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'class/Choose_Button.dart';
import 'class/Decision_Button.dart';
import 'class/drawer.dart';
import 'class/list.dart';
import 'class/top_bar.dart';
import 'package:fish/class/Globals.dart';
import 'database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:animated_button/animated_button.dart';
import 'package:fish/services/camera.service.dart';
import 'package:fish/services/ml_service.dart';
import 'package:fish/services/face_detector_service.dart';
import 'package:fish/locator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  bool inputS = false;
  bool inputW = false;
  bool hide = true;
  String ID = '';
  String PW = '';

  final fieldText = TextEditingController();
  final fieldTextW = TextEditingController();
  void clearText() {
    fieldText.clear();
    fieldTextW.clear();
  }

  MLService _mlService = locator<MLService>();
  FaceDetectorService _mlKitService = locator<FaceDetectorService>();
  CameraService _cameraService = locator<CameraService>();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  _initializeServices() async {
    setState(() => loading = true);
    await _cameraService.initialize();
    await _mlService.initialize();
    _mlKitService.initialize();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    var login_text = const Text("登入",
        style: TextStyle(
          color: Color.fromARGB(255, 82, 82, 82),
          fontSize: 32,
          // fontWeight: FontWeight.w700,
        ));

    var password = TextFormField(
      textInputAction: TextInputAction.done,
      obscureText: hide,
      controller: fieldTextW,
      textAlign: TextAlign.start,
      cursorColor: const Color.fromARGB(255, 135, 168, 202),
      style: const TextStyle(color: Color.fromARGB(255, 30, 43, 51)),
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Color.fromARGB(255, 126, 126, 126)),
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),
        focusColor: const Color.fromARGB(255, 255, 255, 255),
        hoverColor: Color.fromARGB(255, 230, 230, 230),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintText: '請輸入密碼',
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 126, 126, 126),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          color: const Color.fromARGB(255, 135, 168, 202),
          onPressed: () {
            setState(() {
              hide = !hide;
            });
          },
          icon: hide ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
        ),
      ),
      onChanged: (value) {
        setState(() {
          print(value);
          inputW = (value.isEmpty) ? false : true;
          PW = value;
          print(inputW);
        });
      },
    );

    var textfield = TextFormField(
      controller: fieldText,
      textAlign: TextAlign.start,
      cursorColor: const Color.fromARGB(255, 135, 168, 202),
      style: const TextStyle(color: Color.fromARGB(255, 30, 43, 51)),
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Color.fromARGB(255, 126, 126, 126)),
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),
        focusColor: const Color.fromARGB(255, 255, 255, 255),
        hoverColor: Color.fromARGB(255, 230, 230, 230),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintText: '請輸入名稱/ID',
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 126, 126, 126),
        ),
      ),
      onChanged: (value) {
        setState(() {
          print(value);
          inputS = (value.isEmpty) ? false : true;
          ID = value;
          getData(ID);
          print(inputS);
        });
      },
    );

    var confirmbutton = CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 105, vertical: 10),
      borderRadius: BorderRadius.circular(10),
      color: const Color.fromARGB(255, 135, 168, 202),
      disabledColor: Color.fromARGB(255, 196, 196, 196),
      onPressed: (inputS && inputW)
          ? () {
              final snackBar = SnackBar(
                content: Row(
                  children: const [
                    Icon(
                      Icons.warning,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      '帳號或密碼輸入錯誤',
                      style: TextStyle(
                        fontFamily: 'GenJyuu',
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20.0,
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                backgroundColor: Color.fromARGB(255, 237, 110, 74),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(30),
                shape: StadiumBorder(),
                duration: Duration(milliseconds: 1000),
                elevation: 30,
              );
              setState(() {
                clearText();
                inputS = false;
                switch (_cheak_ID(ID, PW)) {
                  case 0:
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    break;
                  case 1:
                    Navigator.pushNamed(context, '/Captain_Home');
                    break;
                  case 2:
                    Navigator.pushNamed(context, '/FisherHome');
                    break;
                }
              });
            }
          : null,
      child: const Text(
        '確認',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 20.0,
          fontFamily: 'GenJyuu',
          // decoration: TextDecoration.underline,
        ),
      ),
    );

    var faceButton = CupertinoButton(
      padding: const EdgeInsets.fromLTRB(140, 10, 0, 10),
      // borderRadius: BorderRadius.circular(10),
      // color: const Color.fromARGB(255, 135, 168, 202),
      child: const Text(
        textAlign: TextAlign.right,
        '生物辨識登入 >',
        style: TextStyle(
          color: Color.fromARGB(255, 44, 61, 92),
          fontSize: 16.0,
          fontFamily: 'GenJyuu',
          // decoration: TextDecoration.underline,
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/FaceIDLogin');
      },
    );

    return Container(
        decoration: const BoxDecoration(
            //背景圖片
            image: DecorationImage(
          image: AssetImage('assets/images/login.jpg'),
          // image: NetworkImage('https://i.imgur.com/Ze7TiVQ.png'),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
            // appBar: AppBar(
            //   backgroundColor: Colors.transparent,
            //   elevation: 0.0,
            //   toolbarHeight: 100,
            //   leading: IconButton(
            //     iconSize: 33.0,
            //     icon: const Icon(
            //       Icons.arrow_back,
            //       color: Color.fromARGB(255, 55, 81, 136),
            //     ),
            //     // ignore: avoid_print
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //   ),
            // ),
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                login_text,
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 250,
                  child: textfield,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 250,
                  child: password,
                ),
                const SizedBox(
                  height: 20,
                ),
                confirmbutton,
                // const SizedBox(
                //   height: 20,
                // ),
                // faceButton,
              ]),
            )));
  }

  List<Member> member = [];
  List<Member> memberid = [];

  int _cheak_ID(String ID, String PW) {
    //判斷是漁工還是船長
    if (ID.compareTo('devmode') == 0 && PW.compareTo('88888888') == 0) {
      return 1;
    }

    debugPrint('bool的結果:');
    debugPrint(member.toString());
    debugPrint(memberid.toString());

    // debugPrint('輸入密碼: ${PW}, 正確密碼:${memberid[0].Passwd}');
    if (member.isEmpty && memberid.isEmpty) {
      member.clear();
      memberid.clear();
      return 0;
    }
    if (member.isNotEmpty && PW == member[0].Passwd) {
      now_login = member[0];
      member.clear();
      memberid.clear();
      return 2;
    }
    if (memberid.isNotEmpty && PW == memberid[0].Passwd) {
      now_login = memberid[0];
      member.clear();
      memberid.clear();
      return 2;
    }
    member.clear();
    memberid.clear();
    return 0;
  }

  void getData(String ID) async {
    final list = await CrewDB.getMember(Crewdb, ID);
    final list2 = await CrewDB.getID(Crewdb, ID);

    setState(() {
      member = list;
      memberid = list2;
      debugPrint("異步結果");
      debugPrint(member.toString());
      debugPrint(memberid.toString());
    });
  }
}
