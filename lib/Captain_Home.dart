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
import 'database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

// ignore: camel_case_types
class Captain_Home extends StatefulWidget {
  const Captain_Home({Key? key}) : super(key: key);

  @override
  State<Captain_Home> createState() => _Captain_HomeState();
}

// ignore: camel_case_types
class _Captain_HomeState extends State<Captain_Home> {
  void updateList(String value) {}
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // final GlobalKey<StepsState> _key = GlobalKey();
  final PageController controller = PageController(initialPage: 1000);
  List<Member> searchList = [];

  void getData() async {

    searchList = await CrewDB.getMember(Crewdb);
  }

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
          state: 0,
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
                    '               工時登記',
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
              TextField(
                //搜尋欄
                onChanged: (value) {
                  setState(() {
                    filterSearchResults(value);
                  });
                },
                cursorColor: const Color.fromARGB(255, 135, 168, 202),
                style: const TextStyle(color: Color.fromARGB(255, 30, 43, 51)),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                  labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 126, 126, 126)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  focusColor: const Color.fromARGB(255, 255, 255, 255),
                  hoverColor: Color.fromARGB(255, 230, 230, 230),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide.none,
                  ),
                  hintText: '請輸入名稱/ID',
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 126, 126, 126),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: const Color.fromARGB(255, 135, 168, 202),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ChoiceChipDemo(), //工作與用餐按鈕
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (prev == -1) prev = 1000;
                                // aTime = aTime.subtract(const Duration(days: 1));
                                controller.previousPage(
                                  duration: Duration(milliseconds: 350),
                                  curve: Curves.easeInOut,
                                );
                              });
                            },
                            icon: Icon(Icons.chevron_left),
                            color: Color.fromARGB(255, 82, 82, 82),
                          ),
                          CupertinoButton(
                            child: Text(
                              '${aTime.year}/${aTime.month}/${aTime.day}',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 82, 82, 82),
                                fontSize: 16.0,
                                // decoration: TextDecoration.underline,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                prev = -1;
                                controller.animateToPage(
                                  1000,
                                  duration: Duration(milliseconds: 380),
                                  curve: Curves.easeInOut,
                                );
                                aTime = currentTime;
                              });
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (prev == -1) prev = 1000;
                                controller.nextPage(
                                    duration: Duration(milliseconds: 350),
                                    curve: Curves.easeIn);
                                // aTime = aTime.add(const Duration(days: 1));
                              });
                            },
                            icon: Icon(Icons.chevron_right),
                            color: Color.fromARGB(255, 82, 82, 82),
                          ),
                        ],
                      ),
                    ),

                    FMCupertinoButtonVC(),
                  ]),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                // child: Steps(),
                child: _pagechange(),
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pagechange() {
    return PageView.builder(
      controller: controller,
      // itemCount: 1000,
      itemBuilder: (context, index) {
        return Steps(namelist: searchList);
      },
      onPageChanged: (int page) {
        setState(() {
          checkState = false;
          print('page: $page');
          print('prev: $prev');
          if (prev != -1) {
            aTime = (prev > page)
                ? aTime.subtract(const Duration(days: 1))
                : (prev == page)
                    ? currentTime
                    : aTime.add(const Duration(days: 1));
            prev = page;
          } else {
            if (page == 1000) prev = 1000;
          }
        });
      },
    );
  }

  void filterSearchResults(String query) async {
    List<Member> dummySearchList = [];
    dummySearchList.addAll(await CrewDB.getMember(Crewdb));
    if (query.isNotEmpty) {
      List<Member> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.Name.contains(query.toUpperCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        checkState = false;
        searchList.clear();
        searchList.addAll(dummyListData);
        print(searchList.length);
      });
      return;
    } else {
      setState(() async {
        searchList.clear();
        // searchList.addAll(getList());
        searchList.addAll(await CrewDB.getMember(Crewdb));
        // searchList = globalList;
        print('global size:');
        // print(globalList.length);
      });
    }
  }
}
