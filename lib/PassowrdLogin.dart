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

class PasswordLogin extends StatefulWidget {
  const PasswordLogin({Key? key}) : super(key: key);

  @override
  State<PasswordLogin> createState() => _PasswordLogin();
}

class _PasswordLogin extends State<PasswordLogin> {
  bool inputS = false;
  bool hide = true;
  final fieldText = TextEditingController();
  void clearText() {
    fieldText.clear();
  }

  @override
  Widget build(BuildContext context) {
    var login_text = const Text("密碼登入",
        style: TextStyle(
          color: Color.fromARGB(255, 82, 82, 82),
          fontSize: 32,
          // fontWeight: FontWeight.w700,
        ));

    var textfield = TextField(
      obscureText: hide,
      controller: fieldText,
      textAlign: TextAlign.start,
      cursorColor: const Color.fromARGB(255, 135, 168, 202),
      style: const TextStyle(color: Color.fromARGB(255, 30, 43, 51)),
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Color.fromARGB(255, 126, 126, 126)),
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintText: '請輸入密碼',
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 126, 126, 126),
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
          inputS = (value.isEmpty) ? false : true;
          print(inputS);
        });
      },
    );

    var confirmbutton = CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 105, vertical: 10),
      borderRadius: BorderRadius.circular(10),
      color: const Color.fromARGB(255, 135, 168, 202),
      disabledColor: Color.fromARGB(255, 196, 196, 196),
      onPressed: inputS
          ? () {
              setState(() {
                clearText();
                inputS = false;
                if (passRight) {
                  Navigator.pushNamed(context, '/Captain_Home');
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
                Container(
                  child: textfield,
                  width: 250,
                  // child: Row(
                  //   children: [Expanded(child: textfield), eyebutton],
                  // ),
                ),
                const SizedBox(
                  height: 20,
                ),
                confirmbutton,
              ]),
            )));
  }
}
