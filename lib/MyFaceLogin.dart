import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'class/Choose_Button.dart';
import 'class/Decision_Button.dart';
import 'class/drawer.dart';
import 'class/list.dart';
import 'class/top_bar.dart';
import 'class/Globals.dart';
import 'package:camera/camera.dart';

class MyFaceIDLogin extends StatefulWidget {
  const MyFaceIDLogin({Key? key}) : super(key: key);

  @override
  State<MyFaceIDLogin> createState() => _MyFaceIDLogin();
}

class _MyFaceIDLogin extends State<MyFaceIDLogin> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<CameraDescription> _getCameraDescription() async {
    List<CameraDescription> cameras = await availableCameras();
    return cameras.firstWhere((CameraDescription camera) => camera.lensDirection == CameraLensDirection.back);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/login.jpg'),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
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
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(),
      ),
    );
  }
}
