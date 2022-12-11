import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:page_transition/page_transition.dart';
import 'Globals.dart';
import '../time.dart';
import '../Captain_Home.dart';
import '../PersonnelManagement.dart';

class EditPage extends StatelessWidget {
  //點開後
  EditPage(
    this.name,
    this.st,
    this.onClose, {
    Key? key,
  }) : super(key: key);
  bool st;
  Namelist name;
  final void Function() onClose;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 245, 245, 245),
        //     image: DecorationImage(
        //   image: AssetImage('assets/images/background.jpg'),
        // fit: BoxFit.cover,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 135, 168, 202),
          elevation: 0.0,
          toolbarHeight: 70,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Color.fromARGB(255, 255, 255, 255),
            onPressed: onClose,
          ),
          title: st ? Text('編輯資料') : Text('新增檔案'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 30),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _item('姓名', name.title, false),
                  const SizedBox(
                    height: 20,
                  ),
                  _item('編號', '02', true),
                  const SizedBox(
                    height: 20,
                  ),
                  _item('工作場所', '甲板', false),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(String ttle, String value, bool modi) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.anchor,
          color: Color.fromARGB(255, 142, 160, 197),
        ),
        const SizedBox(
          width: 20,
        ),
        Text(
          ttle,
          style: const TextStyle(
            color: Color.fromARGB(255, 82, 82, 82),
            fontSize: 18.0,
            // decoration: TextDecoration.underline,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          width: 250,
          child: TextFormField(
            readOnly: modi,
            initialValue: value,
            textAlign: TextAlign.start,
            cursorColor: const Color.fromARGB(255, 135, 168, 202),
            style: const TextStyle(
              color: Color.fromARGB(255, 82, 82, 82),
              fontSize: 18.0,
            ),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25.7),
              ),
              labelStyle:
                  const TextStyle(color: Color.fromARGB(255, 126, 126, 126)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              filled: true,
              fillColor: const Color.fromARGB(255, 245, 245, 245),
              focusColor: const Color.fromARGB(255, 255, 255, 255),
              hoverColor: Color.fromARGB(255, 230, 230, 230),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }
}
