import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_geometry.dart';
import 'class/Choose_Button.dart';
import 'class/Decision_Button.dart';
import 'class/drawer.dart';
import 'class/list.dart';
import 'class/top_bar.dart';
import 'class/Globals.dart';
import 'package:date_format/date_format.dart';
import 'database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

class FisherHome extends StatefulWidget {
  const FisherHome({Key? key}) : super(key: key);

  @override
  State<FisherHome> createState() => _FisherHomeState();
}

// ignore: camel_case_types
class _FisherHomeState extends State<FisherHome> {
  void updateList(String value) {}
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // final GlobalKey<StepsState> _key = GlobalKey();
  final PageController controller = PageController(initialPage: 1000);
  List<Member> searchList = [];

  void getData() async {
    searchList = await CrewDB.getMember(Crewdb);
  }

  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool showLeading = false;
  bool showTrailing = false;
  double groupAligment = -1.0;
  Namelist now = now_login;
  int? _timerange = 0;
  List<Timelist> localtimelist = getunconfirmed();

  int? _value = 0;
  List<int> isChecked = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      //主體是Container
      decoration: const BoxDecoration(
          //背景圖片
          image: DecorationImage(
        image: AssetImage('assets/images/fisherman.jpg'),
        fit: BoxFit.cover,
      )),

      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        body: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 135, 168, 202),
              ),
              child: Column(
                children: [
                  _ledding(),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            _home(),
                            const SizedBox(
                              height: 10,
                            ),
                            _timeout(),
                          ],
                        ),
                        _logout(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: (_value == 0) ? _mainpage() : _timeoutpage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeoutpage() {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Expanded(
            child: ListView.builder(
          padding:
              const EdgeInsets.only(top: 0, right: 10, bottom: 100, left: 10),
          itemBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _timeoutcard(index),
          ),
          itemCount: 15,
        ))
      ],
    );
  }

  Widget _timeoutcard(int index) {
    var nowT = localtimelist[0].stTime.subtract(Duration(days: (index + 100)));
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.warning,
          color: Color.fromARGB(255, 226, 67, 67),
        ),
        title: Text(
          formatDate(
              nowT, [yyyy, '/', mm, '/', dd, '           連續休息時間少於10小時！']),
          style: TextStyle(
            color: Color.fromARGB(255, 82, 82, 82),
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _mainpage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
        ),
        _timebuttom(),
        SizedBox(
          height: 30,
        ),
        Expanded(
          child: _worktimelist(_timerange!),
        ),
      ],
    );
  }

  Widget _worktimelist(int state) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0, right: 10, bottom: 100, left: 10),
      itemBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: _buildTiles(index, state),
      ),
      itemCount: (state + 3) * (state + 1),
    );
  }

  Widget _buildTiles(int index, int state) {
    var nowT = localtimelist[0]
        .stTime
        .subtract(Duration(days: (index + (state + 3) * (state + 1))));
    return ExpansionTile(
      key: PageStorageKey<int>(index + (state + 3) * (state + 1)),
      initiallyExpanded: (state == 0),
      // tilePadding: EdgeInsets.fromLTRB(0, 0, 458, 0),
      leading: (state == 0)
          ? Checkbox(
              fillColor: MaterialStateProperty.all(Colors.blueGrey),
              // color: Color.fromARGB(255, 55, 81, 136),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              checkColor: Colors.white,
              value: isChecked.contains(index),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    isChecked.add(index);
                  } else {
                    isChecked.remove(index);
                  }
                });
              },
            )
          : const SizedBox(
              width: 20,
            ),
      title: Text(
        formatDate(nowT, [yyyy, '/', mm, '/', dd]),
        style: const TextStyle(
          color: Color.fromARGB(255, 55, 81, 136),
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
        ),
      ),
      children: [
        Container(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: _lis(),
          // Column(children: [_row()]),
        )
      ],
    );
  }

  Widget _lis() {
    return Column(
        children: List<Widget>.generate(localtimelist.length, (ID) {
      var _stime = localtimelist[ID].stTime;
      var _etime = localtimelist[ID].endTime;
      return Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(15, 5, 10, 5),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 229, 236, 243),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(children: [
              (localtimelist[ID].state == 0)
                  ? const Icon(
                      color: Color.fromARGB(255, 142, 160, 197),
                      Icons.local_dining)
                  : const Icon(
                      color: Color.fromARGB(255, 44, 84, 121),
                      FontAwesome5Solid.fish),
              const SizedBox(
                width: 15,
              ),
              (localtimelist[ID].state == 0)
                  ? const Text(
                      '用餐',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 142, 160, 197),
                      ),
                    )
                  : const Text(
                      '工作',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 44, 84, 121),
                      ),
                    ),
              const SizedBox(
                width: 15,
              ),
              Text(
                formatDate(_stime, [HH, ':', nn]),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 81, 105, 162),
                ),
              ),
              const Text(
                ' 至 ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 81, 105, 162),
                ),
              ),
              Text(
                formatDate(_etime, [HH, ':', nn]),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 81, 105, 162),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              (localtimelist[ID].state == 1)
                  ? Text(
                      '${(_etime.difference(_stime).inMinutes) / 60}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 81, 105, 162),
                      ),
                    )
                  : const SizedBox(
                      width: 15,
                    ),
              (localtimelist[ID].state == 1)
                  ? const Text(
                      '小時',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 81, 105, 162),
                      ),
                    )
                  : const SizedBox(
                      width: 15,
                    ),
            ]),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      );
    }));
  }

  Widget _timebuttom() {
    return Wrap(
      spacing: 50,
      children: [
        const SizedBox(
          width: 0,
        ),
        ChoiceChip(
          label: (_timerange == 0)
              ? const Text(
                  '未確認',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 18,
                  ),
                )
              : const Text(
                  '未確認',
                  style: TextStyle(
                    color: Color.fromARGB(255, 135, 168, 202),
                    fontSize: 18,
                  ),
                ),
          labelPadding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
          backgroundColor: const Color.fromARGB(255, 224, 232, 248),
          selectedColor: const Color.fromARGB(255, 81, 105, 162),
          selected: _timerange == 0,
          onSelected: (value) {
            setState(() {
              isChecked.clear();
              _timerange = 0;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        ChoiceChip(
          label: (_timerange == 2)
              ? const Text(
                  '本月',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 18,
                  ),
                )
              : const Text(
                  '本月',
                  style: TextStyle(
                    color: Color.fromARGB(255, 135, 168, 202),
                    fontSize: 18,
                  ),
                ),
          labelPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          backgroundColor: const Color.fromARGB(255, 224, 232, 248),
          selectedColor: const Color.fromARGB(255, 81, 105, 162),
          selected: _timerange == 2,
          onSelected: (value) {
            setState(() {
              isChecked.clear();
              _timerange = 2;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        ChoiceChip(
          label: (_timerange == 1)
              ? const Text(
                  '本週',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 18,
                  ),
                )
              : const Text(
                  '本週',
                  style: TextStyle(
                    color: Color.fromARGB(255, 135, 168, 202),
                    fontSize: 18,
                  ),
                ),
          labelPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          backgroundColor: const Color.fromARGB(255, 224, 232, 248),
          selectedColor: const Color.fromARGB(255, 81, 105, 162),
          selected: _timerange == 1,
          onSelected: (value) {
            setState(() {
              isChecked.clear();
              _timerange = 1;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        _cupertinoButton(),
      ],
    );
  }

  CupertinoButton _cupertinoButton() {
    return CupertinoButton(
      color: const Color.fromARGB(255, 237, 110, 74),
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      disabledColor: Colors.grey,
      onPressed: (isChecked.isNotEmpty)
          ? () {
              setState(() {
                _showAlertDialog(context);
              });
            }
          : null,
      borderRadius: BorderRadius.circular(50),
      child: const Text(
        '確認工時',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 18.0,
          fontFamily: 'GenJyuu',
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text(
          '是否確認登記時段',
          style: TextStyle(
            fontFamily: 'GenJyuu',
          ),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            SizedBox(
              height: 10.0,
            ),
            Text(
              '登記完經確認後將無法修改',
              style: TextStyle(
                color: Color.fromARGB(255, 32, 42, 61),
                // fontSize: 14.0,
                fontFamily: 'GenJyuu',
              ),
            ),
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              '取消',
              style: TextStyle(
                color: Color.fromARGB(255, 69, 101, 160),
                fontWeight: FontWeight.normal,
                fontFamily: 'GenJyuu',
              ),
            ),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              setState(() {
                isChecked.clear();
              });

              Navigator.pop(context);
            },
            child: const Text(
              '確認',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'GenJyuu',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logout() {
    return Container(
      width: 250,
      height: 100,
      padding: const EdgeInsets.only(top: 50, left: 0, right: 15.0),
      // ignore: sort_child_properties_last
      child: ListTile(
        onTap: () {
          Navigator.popAndPushNamed(context, '/');
        },
        leading: const Icon(
          Icons.logout,
          size: 30,
        ),
        iconColor: const Color.fromARGB(255, 245, 245, 245),
        title: const Text(
          '登出系統',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _home() {
    return ChoiceChip(
      pressElevation: 0,
      side: BorderSide(
        color: const Color.fromARGB(255, 135, 168, 202),
      ),
      padding: EdgeInsets.fromLTRB(5, 10, 125, 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      avatar: (_value == 0)
          ? const Icon(
              size: 30,
              Icons.sensor_occupied,
              color: Color.fromARGB(255, 81, 105, 162),
            )
          : const Icon(
              size: 30,
              Icons.person,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
      label: (_value == 0)
          ? const Text(
              '個人頁面',
              style: TextStyle(
                color: Color.fromARGB(255, 81, 105, 162),
                fontSize: 16,
              ),
            )
          : const Text(
              '個人頁面',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 16,
              ),
            ),
      selected: _value == 0,
      labelPadding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
      backgroundColor: const Color.fromARGB(255, 135, 168, 202),
      selectedColor: const Color.fromARGB(255, 188, 203, 231),
      onSelected: (bool selected) {
        print(selected);
        setState(() {
          _value = 0;
        });
      },
    );
  }

  Widget _timeout() {
    return ChoiceChip(
      pressElevation: 0,
      side: const BorderSide(
        color: Color.fromARGB(255, 135, 168, 202),
      ),
      padding: EdgeInsets.fromLTRB(5, 10, 125, 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      avatar: (_value == 1)
          ? const Icon(
              size: 30,
              Icons.notifications_active,
              color: Color.fromARGB(255, 81, 105, 162),
            )
          : const Icon(
              size: 30,
              Icons.notifications,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
      label: (_value == 1)
          ? const Text(
              '超時紀錄',
              style: TextStyle(
                color: Color.fromARGB(255, 81, 105, 162),
                fontSize: 16,
              ),
            )
          : const Text(
              '超時紀錄',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 16,
              ),
            ),
      selected: _value == 1,
      labelPadding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
      backgroundColor: const Color.fromARGB(255, 135, 168, 202),
      selectedColor: const Color.fromARGB(255, 188, 203, 231),
      onSelected: (bool selected) {
        print(selected);
        setState(() {
          _value = 1;
        });
      },
    );
  }

  Widget _ledding() {
    return Container(
        width: 250,
        height: 170,
        padding: const EdgeInsets.only(top: 70, left: 5, right: 15.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fish2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        // ignore: sort_child_properties_last
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 10,
            ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 55, 81, 136),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(
                color: Colors.white,
                Icons.sentiment_very_satisfied,
                size: 45,
                fill: 1,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  now.title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                Text(
                  '#${now.title}',
                  style: const TextStyle(
                      fontSize: 14.0,
                      color: Color.fromARGB(255, 226, 242, 255)),
                ),
              ],
            )
          ],
        ));
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
}
