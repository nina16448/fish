import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'Globals.dart';
import '../database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';

class FMCupertinoButtonVC extends StatefulWidget {
  FMCupertinoButtonVC({
    super.key,
    // required this.state,
  });

  @override
  FMCupertinoButtonState createState() => FMCupertinoButtonState();
  // bool state;
}

class FMCupertinoButtonState extends State<FMCupertinoButtonVC> {
  List<WorkSheet> rec = [];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: _safeArea(),
    );
  }

  SafeArea _safeArea() {
    return SafeArea(child: _column());
  }

  Row _column() {
    return Row(
      children: [
        Container(
          width: 190,
          color: Colors.transparent,
          alignment: Alignment.centerRight,
          height: 45,
          child: _cupertinoButton(),
        ),
        const SizedBox(
          width: 21.0,
        ),
      ],
    );
  }

  CupertinoButton _cupertinoButton() {
    return CupertinoButton(
      color: const Color.fromARGB(255, 237, 110, 74),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      disabledColor: Colors.grey,
      onPressed: () {
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
                '未選擇任何登記時段',
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
          duration: Duration(milliseconds: 800),
          elevation: 30,
        );
        setState(() {
          checkState ? _showAlertDialog(context) : ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      },
      borderRadius: BorderRadius.circular(50),
      child: const Text(
        '確認登記',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 20.0,
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
              debugPrint('確認:D');
              setState(() {
                for (var key in update_queue.keys) {
                  update(update_queue[key]!);
                  timetostring(update_queue[key]!);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                update_queue.clear();
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

  void update(WorkSheet addk) async {
    final getlist = await SheetDB.getsheet(addk.MemberId, addk.Date, Sheetdb);
    setState(() {
      // rec = getlist;
      debugPrint('有沒有找到? ${getlist.isNotEmpty}');

      if (getlist.isEmpty) {
        addtime(addk);

        debugPrint('add time: ${addk.MemberId} in ${addk.Date}');
      } else {
        updatetime(addk);

        debugPrint('update time: ${addk.MemberId} in ${addk.Date}');
      }
    });
  }

  void addtime(WorkSheet addk) async {
    await SheetDB.AddWorkTime(addk, Sheetdb);
  }

  void updatetime(WorkSheet addk) async {
    await SheetDB.updateSheet(addk, Sheetdb);
  }

  void timetostring(WorkSheet addk) {
    Timelist section = Timelist(0, 'init', 'endTime', 0.0);
    List<Timelist> datalist = [];
    WorkTime fisherformat = WorkTime(
      SheetId: addk.SheetId,
      MemberId: addk.MemberId,
      Date: addk.Date,
      Datalist: 'null',
      State: addk.State,
    );
    // setState(() {
    for (int i = 0; i < addk.Sheet.length; i++) {
      debugPrint('工作狀態: 第$i格 新${addk.Sheet[i]}, 舊${section.state}');
      // debugPrint('陣列狀態:S${datalist.toString()}');

      // if (section.state != addk.Sheet[i]) {
      if (section.stTime.compareTo('init') == 0) {
        //   //開始一段時間段
        section.dura = 0;
        section.stTime = numtoTime[i];
      }

      if (i != (addk.Sheet.length - 1) && addk.Sheet[i] != addk.Sheet[i + 1]) {
        section.endTime = numtoTime[i + 1];
        debugPrint('工作狀態: 開始${section.stTime} 結束: ${section.endTime}, dura: ${section.dura}');
        if (addk.Sheet[i] != 0 && section.state != 0) {
          section.dura += 0.5;
          section.state = addk.Sheet[i];
          debugPrint('加之前陣列:S${datalist.toString()}');
          datalist.add(Timelist(section.state, section.stTime, section.endTime, section.dura));
          debugPrint('新增時間段: ${section.toString()}');
          debugPrint('陣列:S${datalist.toString()}');
        }
        section.dura = 0;
        section.stTime = 'init';
      }
      if (i == (addk.Sheet.length - 1)) {
        section.endTime = numtoTime[i + 1];
        if (addk.Sheet[i] != 0 && section.state != 0) {
          section.dura += 0.5;
          section.state = addk.Sheet[i];
          debugPrint('加之前陣列:S${datalist.toString()}');
          datalist.add(Timelist(section.state, section.stTime, section.endTime, section.dura));
          debugPrint('新增時間段: ${section.toString()}');
          debugPrint('陣列:S${datalist.toString()}');
        }
      }

      // }
      section.state = addk.Sheet[i];
      section.dura += 0.5;
      debugPrint('工作狀態: 開始${section.stTime} 結束: ${section.endTime}, dura: ${section.dura}');
    }

    fisherformat.Datalist = jsonEncode(datalist);
    debugPrint('要加密帳陣列:S${datalist.toString()}');
    // debugPrint(jsonDecode(fisherformat.Datalist));
    uploadfish(fisherformat);

    // }
    // );
  }

  void uploadfish(WorkTime addk) async {
    final getlist = await WorkTimeDB.getsheet(addk.MemberId, addk.Date, WorkTimedb);
    setState(() {
      // rec = getlist;
      debugPrint('有沒有找到? ${getlist.isNotEmpty}');

      if (getlist.isEmpty) {
        addfish(addk);

        debugPrint('add fish time: ${addk.MemberId} in ${addk.Date}');
      } else {
        updatefish(addk);

        debugPrint('update fish time: ${addk.MemberId} in ${addk.Date}');
      }
      debugPrint(addk.toString());
    });
  }

  void addfish(WorkTime addk) async {
    await WorkTimeDB.AddWorkTime(addk, WorkTimedb);
  }

  void updatefish(WorkTime addk) async {
    await WorkTimeDB.updateSheet(addk, WorkTimedb);
  }
}
