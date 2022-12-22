import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:fish/class/Timeout__Warning.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
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
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';

class FisherHome extends StatefulWidget {
  const FisherHome({Key? key}) : super(key: key);

  @override
  State<FisherHome> createState() => _FisherHomeState();
}

class datel {
  datel({
    required this.date,
    required this.cost,
    required this.sheet,
  });
  String date;
  double cost;
  List<Timelist> sheet;
}

// ignore: camel_case_types
class _FisherHomeState extends State<FisherHome> {
  void updateList(String value) {}
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // final GlobalKey<StepsState> _key = GlobalKey();
  final PageController controller = PageController(initialPage: 1000);
  // List<Member> searchList = [];
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool showLeading = false;
  bool showTrailing = false;
  double groupAligment = -1.0;
  Member now = now_login;
  int? _timerange = 0;
  bool _limit = false;

  // List<Timelist> localtimelist = [];
  List<Timelist> localtime = [];
  List<dynamic> recmap = [];
  int? _value = 0;
  List<int> isChecked = [];
  List<datel> showout = [];
  List<String> queue = [];
  List<WarningRecord> locallimit = [];
  double recnum = 0.0;

  void initList() async {
    final list = await WorkTimeDB.getstatesheet(now.Id, 0, WorkTimedb);
    final lim = await WarningDB.getRecord(now.Id, Warningdb);
    recnum = 0.0;
    setState(() {
      locallimit = lim;
      for (int i = 0; i < list.length; i++) {
        recnum = 0.0;
        recmap = jsonDecode(list[i].Datalist);
        localtime = List<Timelist>.from(recmap.map((e) => Timelist.fromJson(e)));

        for (var x in localtime) {
          if (x.state == 2) recnum += x.dura;
        }

        showout.add(
          datel(
            date: list[i].Date,
            cost: recnum,
            sheet: localtime,
          ),
        );
      }
    });
    showout.sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  void initState() {
    super.initState();
    initList();
    showout.sort((a, b) => b.date.compareTo(a.date));
    debugPrint('init');
  }

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
          height: 80,
        ),
        Expanded(
            child: ListView.builder(
          padding: const EdgeInsets.only(top: 0, right: 10, bottom: 100, left: 10),
          itemBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
            child: _timeoutcard(index),
          ),
          itemCount: locallimit.length,
        )),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }

  Widget _timeoutcard(int index) {
    // var nowT = localtimelist[0].stTime.subtract(Duration(days: (index + 100)));
    return Card(
      child: ListTile(
        leading: const Icon(
          size: 30,
          Icons.warning,
          color: Color.fromARGB(255, 226, 67, 67),
        ),
        title: Text(
          '${locallimit[index].Date}           連續休息時間少於10小時！',
          style: TextStyle(
            color: Color.fromARGB(255, 82, 82, 82),
            fontSize: 20.0,
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
        SizedBox(
          height: 50,
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
      itemCount: showout.length,
    );
  }

  Widget _buildTiles(int index, int state) {
    var nowT = showout[index].date;
    return ExpansionTile(
      subtitle: Text('共 ${showout[index].cost} 小時'),
      key: PageStorageKey<int>(index),
      initiallyExpanded: true,
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
                    queue.add(showout[index].date);
                  } else {
                    isChecked.remove(index);
                    queue.remove(showout[index].date);
                  }
                });
              },
            )
          : const SizedBox(
              width: 20,
            ),
      title: Text(
        nowT,
        style: const TextStyle(
          color: Color.fromARGB(255, 55, 81, 136),
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      children: [
        Container(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: _lis(showout[index].sheet),
          // Column(children: [_row()]),
        )
      ],
    );
  }

  Widget _lis(List<Timelist> level) {
    return Column(
        children: List<Widget>.generate(level.length, (ID) {
      var _stime = level[ID].stTime;
      var _etime = level[ID].endTime;
      return Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(15, 5, 10, 5),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 229, 236, 243),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(children: [
              (level[ID].state == 1)
                  ? const Icon(size: 30, color: Color.fromARGB(255, 142, 160, 197), Icons.local_dining)
                  : const Icon(size: 30, color: Color.fromARGB(255, 44, 84, 121), FontAwesome5.fish),
              const SizedBox(
                width: 15,
              ),
              (level[ID].state == 1)
                  ? const Text(
                      '用餐',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 142, 160, 197),
                      ),
                    )
                  : const Text(
                      '工作',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 44, 84, 121),
                      ),
                    ),
              const SizedBox(
                width: 15,
              ),
              Text(
                _stime,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 81, 105, 162),
                ),
              ),
              const Text(
                ' 至 ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 81, 105, 162),
                ),
              ),
              Text(
                _etime,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 81, 105, 162),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              (level[ID].state == 2)
                  ? Text(
                      '${level[ID].dura}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 81, 105, 162),
                      ),
                    )
                  : const SizedBox(
                      width: 15,
                    ),
              (level[ID].state == 2)
                  ? const Text(
                      '小時',
                      style: TextStyle(
                        fontSize: 20,
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
                    fontSize: 22,
                  ),
                )
              : const Text(
                  '未確認',
                  style: TextStyle(
                    color: Color.fromARGB(255, 135, 168, 202),
                    fontSize: 22,
                  ),
                ),
          labelPadding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
          backgroundColor: const Color.fromARGB(255, 224, 232, 248),
          selectedColor: const Color.fromARGB(255, 81, 105, 162),
          selected: _timerange == 0,
          onSelected: (value) {
            setState(() {
              showout.clear();
              getstateList();
              isChecked.clear();
              _timerange = 0;
              // showout.sort((a, b) => b.date.compareTo(a.date));
            });
            // showout.sort((a, b) => b.date.compareTo(a.date));
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
                    fontSize: 22,
                  ),
                )
              : const Text(
                  '本月',
                  style: TextStyle(
                    color: Color.fromARGB(255, 135, 168, 202),
                    fontSize: 22,
                  ),
                ),
          labelPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          backgroundColor: const Color.fromARGB(255, 224, 232, 248),
          selectedColor: const Color.fromARGB(255, 81, 105, 162),
          selected: _timerange == 2,
          onSelected: (value) {
            setState(() {
              showout.clear();
              getmonthList();
              isChecked.clear();
              _timerange = 2;
              // showout.sort((a, b) => b.date.compareTo(a.date));
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        ChoiceChip(
          label: (_timerange == 1)
              ? const Text(
                  '全部',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 22,
                  ),
                )
              : const Text(
                  '全部',
                  style: TextStyle(
                    color: Color.fromARGB(255, 135, 168, 202),
                    fontSize: 22,
                  ),
                ),
          labelPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          backgroundColor: const Color.fromARGB(255, 224, 232, 248),
          selectedColor: const Color.fromARGB(255, 81, 105, 162),
          selected: _timerange == 1,
          onSelected: (value) {
            setState(() {
              showout.clear();
              getallList();
              isChecked.clear();
              _timerange = 1;
              // showout.sort((a, b) => b.date.compareTo(a.date));
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
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
      disabledColor: Colors.grey,
      onPressed: (isChecked.isNotEmpty)
          ? () {
              setState(() {
                _showAlertDialog(context);
              });
            }
          : null,
      borderRadius: BorderRadius.circular(10),
      child: const Text(
        '確認工時',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 22.0,
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
            fontSize: 20,
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
                fontSize: 18.0,
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
            isDestructiveAction: true,
            onPressed: () {
              for (var key in queue) {
                cheaktime(key);
              }
              setState(() {
                isChecked.clear();
                queue.clear();
                showout.clear();
                updlimit();
                getstateList();
                showout.sort((a, b) => b.date.compareTo(a.date));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                // ElegantNotification(
                //   // title: Text("已確認工時"),
                //   description: Text("已確認工時"),
                //   icon: Icon(
                //     Icons.access_alarm,
                //     color: Colors.orange,
                //   ),
                //   progressIndicatorColor: Colors.orange,
                // ).show(context);
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
          '已確認工時',
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
    backgroundColor: Color.fromARGB(255, 255, 238, 89),
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(30),
    shape: StadiumBorder(),
    duration: Duration(milliseconds: 800),
    elevation: 30,
  );

  Widget _logout() {
    return Container(
      width: 340,
      height: 100,
      padding: const EdgeInsets.only(top: 30, left: 0, right: 15.0, bottom: 0),
      // ignore: sort_child_properties_last
      child: ListTile(
        onTap: () {
          Navigator.popUntil(context, ModalRoute.withName('/'));
        },
        leading: const Icon(
          Icons.logout,
          size: 40,
        ),
        iconColor: const Color.fromARGB(255, 245, 245, 245),
        title: const Text(
          '登出系統',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 22,
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
      padding: const EdgeInsets.fromLTRB(10, 15, 180, 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      avatar: Icon(
        size: 40,
        Icons.person,
        color: (_value == 0) ? Color.fromARGB(255, 81, 105, 162) : Color.fromARGB(255, 255, 255, 255),
      ),
      label: Text(
        '個人頁面',
        style: TextStyle(
          fontSize: 22,
          color: (_value == 0) ? Color.fromARGB(255, 81, 105, 162) : Color.fromARGB(255, 255, 255, 255),
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
      padding: const EdgeInsets.fromLTRB(10, 15, 180, 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      avatar: (_limit == false)
          ? Icon(
              size: 40,
              Icons.notifications,
              color: (_value == 1) ? Color.fromARGB(255, 81, 105, 162) : Color.fromARGB(255, 255, 255, 255),
            )
          : const Icon(
              size: 40,
              Icons.notifications_active,
              color: Color.fromARGB(255, 255, 225, 89),
            ),
      label: Text(
        '超時紀錄',
        style: TextStyle(
          fontSize: 22,
          color: (_value == 1) ? Color.fromARGB(255, 81, 105, 162) : Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      selected: _value == 1,
      labelPadding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
      backgroundColor: const Color.fromARGB(255, 135, 168, 202),
      selectedColor: const Color.fromARGB(255, 188, 203, 231),
      onSelected: (bool selected) {
        _limit = false;
        print(selected);
        setState(() {
          updlimit();
          _value = 1;
        });
      },
    );
  }

  Widget _ledding() {
    return Container(
        width: 350,
        height: 190,
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
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 55, 81, 136),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(
                color: Colors.white,
                Icons.sentiment_very_satisfied,
                size: 50,
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
                  now.Name,
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                Text(
                  '#${now.Id}',
                  style: const TextStyle(fontSize: 16.0, color: Color.fromARGB(255, 226, 242, 255)),
                ),
              ],
            )
          ],
        ));
  }

  void getstateList() async {
    final list = await WorkTimeDB.getstatesheet(now.Id, 0, WorkTimedb);
    recnum = 0.0;

    setState(() {
      for (int i = 0; i < list.length; i++) {
        recnum = 0.0;
        recmap = jsonDecode(list[i].Datalist);
        localtime = List<Timelist>.from(recmap.map((e) => Timelist.fromJson(e)));
        for (var x in localtime) {
          if (x.state == 2) recnum += x.dura;
        }

        showout.add(
          datel(
            date: list[i].Date,
            cost: recnum,
            sheet: localtime,
          ),
        );
      }
    });
    showout.sort((a, b) => b.date.compareTo(a.date));
  }

  void getmonthList() async {
    final time = DateTime.now();
    final list = await WorkTimeDB.getmonthheet(now.Id, formatDate(time, [yyyy, '/', mm, '/00']), formatDate(time, [yyyy, '/', mm, '/32']), WorkTimedb);
    recnum = 0.0;
    setState(() {
      for (int i = 0; i < list.length; i++) {
        recnum = 0.0;
        recmap = jsonDecode(list[i].Datalist);
        localtime = List<Timelist>.from(recmap.map((e) => Timelist.fromJson(e)));
        for (var x in localtime) {
          if (x.state == 2) recnum += x.dura;
        }

        showout.add(
          datel(
            date: list[i].Date,
            cost: recnum,
            sheet: localtime,
          ),
        );
      }
    });
    showout.sort((a, b) => b.date.compareTo(a.date));
  }

  void getallList() async {
    final list = await WorkTimeDB.getwhosheet(now.Id, WorkTimedb);

    setState(() {
      for (int i = 0; i < list.length; i++) {
        recnum = 0.0;
        recmap = jsonDecode(list[i].Datalist);
        localtime = List<Timelist>.from(recmap.map((e) => Timelist.fromJson(e)));
        for (var x in localtime) {
          if (x.state == 2) recnum += x.dura;
        }

        showout.add(
          datel(
            date: list[i].Date,
            cost: recnum,
            sheet: localtime,
          ),
        );
        // showout.sort((a, b) => b.date.compareTo(a.date));
      }
    });
    showout.sort((a, b) => b.date.compareTo(a.date));
  }

  void cheaktime(String date) async {
    final list1 = await SheetDB.getsheet(now.Id, date, Sheetdb);
    final list2 = await WorkTimeDB.getsheet(now.Id, date, WorkTimedb);

    setState(() {
      list1[0].State = 1;
      list2[0].State = 1;
      updatesheetstate(list1[0]);
      updatetimestate(list2[0]);
      debugPrint('更新狀態:${date}');
      debugPrint('${list1[0].State}');
      cheakforlimit(list1[0]);
      showout.clear();
      getstateList();
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  void updatesheetstate(WorkSheet addk) async {
    await SheetDB.updateSheet(addk, Sheetdb);
  }

  void updatetimestate(WorkTime addk) async {
    await WorkTimeDB.updateSheet(addk, WorkTimedb);
  }

  void cheakforlimit(WorkSheet addk) async {
    int count = addk.Sheet.where((n) => n <= 1).length;
    WarningRecord neww = WarningRecord(
      recId: addk.SheetId,
      MemberId: addk.MemberId,
      Name: now.Name,
      Date: addk.Date,
    );

    if (count <= 20) addforlimit(neww);
  }

  void addforlimit(WarningRecord addk) async {
    await WarningDB.Addrecord(addk, Warningdb);
    _limit = true;
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    debugPrint('超時!!已新增超時時段 ${addk.Name} in ${addk.Date}');
  }

  void updlimit() async {
    final lim = await WarningDB.getRecord(now.Id, Warningdb);
    setState(() {
      locallimit = lim;
    });
    locallimit.sort((a, b) => b.Date.compareTo(a.Date));
  }
}
