// ignore_for_file: file_names
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'class/Globals.dart';
import 'class/EditPage.dart';
import 'class/Timeout__Warning.dart';
import 'class/Choose_Button.dart';
import 'class/Decision_Button.dart';
import 'class/drawer.dart';
import 'class/list.dart';
import 'class/top_bar.dart';
import 'class/Settinglist.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

// ignore: camel_case_types
class Management extends StatefulWidget {
  const Management({Key? key}) : super(key: key);

  @override
  State<Management> createState() => _Management();
}

// ignore: camel_case_types
class _Management extends State<Management> {
  void updateList(String value) {}
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      //主體是Container
      decoration: const BoxDecoration(
          //背景圖片
          image: DecorationImage(
        image: AssetImage('assets/images/background.jpg'),
        // image: NetworkImage('https://i.imgur.com/Ze7TiVQ.png'),
        fit: BoxFit.cover,
      )),

      child: Scaffold(
          key: _scaffoldKey,
          drawer: MyDrawer(
            state: 2,
          ),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            toolbarHeight: 100,
            leading: IconButton(
              iconSize: 33.0,
              icon: const Icon(
                Icons.menu,
                color: Color.fromARGB(255, 55, 81, 136),
              ),
              // ignore: avoid_print
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            title: Row(
              textBaseline: TextBaseline.alphabetic,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const Text(' '),
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.only(
                      bottom:
                          2, // This can be the space you need between text and underline
                    ),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: Color.fromARGB(255, 135, 168, 202),
                      width: 2, // This would be the width of the underline
                    ))),
                    child: const Text(
                      '               人員管理',
                      style: TextStyle(
                        color: Color.fromARGB(255, 82, 82, 82),
                        fontSize: 23.0,
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const Text('             '),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                // TimeList(),

                Expanded(child: ManList()),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 6,
            backgroundColor: const Color.fromARGB(255, 237, 110, 74),
            child: Icon(
              size: 35,
              Icons.person_add_alt_1,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            onPressed: () {
              showDataAlert(
                  0,
                  Member(
                    Id: '',
                    Name: '',
                    Passwd: '1234',
                    Position: 'fisherman',
                    Wplace: '',
                  ));
            },
          )),
    );
  }

  showDataAlert(int state, Member root) {
    Member edit = root;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.only(
              top: 10.0,
            ),
            title: Text(
              (state == 0) ? "新增資料" : "修改資料",
              style: TextStyle(fontSize: 24.0),
            ),
            content: Container(
              height: 400,
              width: 500,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(6, 6, 6, 0),
                      child: Text(
                        "姓名",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (name) {
                          edit.Name = name;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '請輸入姓名';
                          }
                          return null;
                        },
                        initialValue: root.Name,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          // hintText: 'Enter Id here',
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(6, 6, 6, 0),
                      child: Text(
                        "ID",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (value) {
                          edit.Id = value;
                        },
                        initialValue: root.Id,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          // hintText: 'Enter Id here',
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(6, 6, 6, 0),
                      child: Text(
                        "工作場所",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 30),
                      child: TextFormField(
                        onChanged: (value) {
                          edit.Wplace = value;
                        },
                        initialValue: root.Wplace,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          // hintText: 'Enter Id here',
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          // setState(() async {
                          await CrewDB.AddMember(edit, Crewdb);
                          // Crewdb = CrewDB.getDB();
                          // });
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 135, 168, 202),
                          // fixedSize: Size(250, 50),
                        ),
                        child: const Text(
                          "確認",
                          style: TextStyle(
                            fontFamily: 'GenJyuu',
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 16.0,
                            // decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
