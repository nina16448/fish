// ignore_for_file: file_names
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'class/Choose_Button.dart';
import 'class/Decision_Button.dart';
import 'class/drawer.dart';
import 'class/list.dart';
import 'class/top_bar.dart';
import 'class/Globals.dart';

class FaceIDLogin extends StatefulWidget {
  const FaceIDLogin({Key? key}) : super(key: key);

  @override
  State<FaceIDLogin> createState() => _FaceIDLogin();
}

class _FaceIDLogin extends State<FaceIDLogin> {
  @override
  Widget build(BuildContext context) {
    var login_text = const Text("生物辨識",
        style: TextStyle(
          color: Color.fromARGB(255, 82, 82, 82),
          fontSize: 32,
          // fontWeight: FontWeight.w700,
        ));

    return Container(
        decoration: const BoxDecoration(
            //背景圖片
            image: DecorationImage(
          image: AssetImage('assets/images/login.jpg'),
          // image: NetworkImage('https://i.imgur.com/Ze7TiVQ.png'),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              toolbarHeight: 100,
              leading: IconButton(
                iconSize: 33.0,
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color.fromARGB(255, 55, 81, 136),
                ),
                // ignore: avoid_print
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            backgroundColor: Colors.transparent,
            body: Center(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                const SizedBox(
                  height: 70,
                ),
                login_text,
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
              ]),
            )));
  }
}
