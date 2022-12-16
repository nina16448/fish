import 'package:flutter/cupertino.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'Globals.dart';
import '../database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

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
              debugPrint('確認:D');
              setState(() {
                for (var key in update_queue.keys) {
                  update(update_queue[key]!);
                  // if (rec.isEmpty) {
                  //   addtime(update_queue[key]!);
                  //   debugPrint('add time: ${update_queue[key]!.MemberId}in${update_queue[key]!.Date}');
                  // } else {
                  //   updatetime(update_queue[key]!);
                  //   debugPrint('update time: ${update_queue[key]!.MemberId}in${update_queue[key]!.Date}');
                  // }
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
}
