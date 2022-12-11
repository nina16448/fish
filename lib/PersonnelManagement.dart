// ignore_for_file: file_names
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  final formGlobalKey = GlobalKey<FormState>();
  List<Member> allmember = [];

  void initList() async {
    final list = await CrewDB.getMember(Crewdb, 'All');
    setState(() {
      allmember = list;
    });
  }

  void updateList(String value) {}
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initList();
  }

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
          leadingWidth: 90,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 100,
          leading: IconButton(
            // padding: EdgeInsets.only(left: 20),
            iconSize: 40.0,
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
                    top: 10,
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
                      fontSize: 30.0,
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

              Expanded(
                  child: ListView.builder(
                padding: const EdgeInsets.only(top: 0, right: 10, bottom: 100),
                itemBuilder: (BuildContext context, int index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: _item(allmember[index], index),
                ),
                itemCount: allmember.length,
              )),
            ],
          ),
        ),
        floatingActionButton: Container(
          width: 100,
          height: 100,
          child: FittedBox(
            child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0, right: 10),
                child: FloatingActionButton(
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
          ),
        ),
      ),
    );
  }

  Widget _item(Member root, int index) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            color: Colors.white,
            child: Slidable(
              groupTag: "alll",
              // Specify a key if the Slidable is dismissible.
              key: ValueKey(index),
              // The end action pane is the one at the right or the bottom side.

              endActionPane: ActionPane(
                // dismissible: DismissiblePane(
                //     dismissThreshold: 0.99,
                //     onDismissed: () {
                //       globalList.remove(root);
                //     }),
                extentRatio: 0.06,
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      setState(() {
                        allmember.remove(root);
                      });
                      delList(root);
                      getData();
                    },
                    backgroundColor: Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                  ),
                ],
              ),

              child: ListTile(
                minVerticalPadding: 20,
                leading: const Icon(
                  size: 40,
                  Icons.anchor,
                  color: Color.fromARGB(255, 142, 160, 197),
                ),
                title: Row(
                  children: [
                    Text(
                      root.Name,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 82, 82, 82),
                        fontSize: 25.0,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      '#${root.Id}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 131, 131, 131),
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    showDataAlert(1, root);
                    print(root.Name);
                  });
                },
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 6.0,
        ),
      ],
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
            // contentPadding: const EdgeInsets.only(
            //   top: 25.0,
            // ),
            titlePadding: EdgeInsets.only(top: 40, left: 40),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            title: Text(
              (state == 0) ? "新增資料" : "修改資料",
              style: TextStyle(fontSize: 30.0),
            ),
            content: Form(
              key: formGlobalKey,
              child: Container(
                height: 600,
                width: 600,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // padding: const EdgeInsets.only(left: 25, right: 25),
                  children: [
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.fromLTRB(6, 6, 6, 0),
                            child: Text(
                              "姓名",
                              style: TextStyle(
                                fontSize: 23.0,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: TextFormField(
                              validator: (String? value) {
                                return (value == null || value.isEmpty)
                                    ? '姓名不可為空'
                                    : null;
                              },
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                              onChanged: (name) {
                                edit.Name = name;
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
                              style: TextStyle(
                                fontSize: 23.0,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: TextFormField(
                              validator: (String? value) {
                                return (value == null || value.isEmpty)
                                    ? 'ID不可為空'
                                    : null;
                              },
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
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
                              style: TextStyle(
                                fontSize: 23.0,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: TextFormField(
                              validator: (String? value) {
                                return null;
                              },
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
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
                          const Padding(
                            padding: EdgeInsets.fromLTRB(6, 6, 6, 0),
                            child: Text(
                              "登入密碼",
                              style: TextStyle(
                                fontSize: 23.0,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: TextFormField(
                              validator: (String? value) {
                                return (value == null || value.isEmpty)
                                    ? '密碼不可為空'
                                    : null;
                              },
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                              onChanged: (value) {
                                edit.Passwd = value;
                              },
                              initialValue: root.Passwd,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                // hintText: 'Enter Id here',
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                    Container(
                      width: double.infinity,
                      height: 80,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (formGlobalKey.currentState == null) {
                            print('is null');
                          } else if (formGlobalKey.currentState!.validate()) {
                            setState(() {
                              (state == 0) ? addList(edit) : editList(edit);
                              getData();
                            });
                            Navigator.of(context).pop();
                          }
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
                            fontSize: 25.0,
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

  void addList(Member addk) async {
    await CrewDB.AddMember(addk, Crewdb);
  }

  void editList(Member addk) async {
    await CrewDB.updateMember(addk, Crewdb);
  }

  void getData() async {
    final list = await CrewDB.getMember(Crewdb);
    setState(() {
      allmember = list;
    });
  }

  void delList(Member addk) async {
    await CrewDB.deleteMember(addk.Id, Crewdb);
  }
}
