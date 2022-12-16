import 'dart:math';
import 'Globals.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import '../database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

class datelimit {
  datelimit(this.Date, this.member, [this.isExpanded = false]);
  String Date;
  List<String> member;
  bool isExpanded;
}

class TimeList extends StatefulWidget {
  const TimeList({Key? key}) : super(key: key);

  @override
  State<TimeList> createState() => _TimeList();
}

class _TimeList extends State<TimeList> {
  List<datelimit> notices = [];
  var rec = Map<String, List<String>>();
  datelimit tmp = datelimit('', []);

  void initList() async {
    final list = await WarningDB.getRecord('All', Warningdb);
    setState(() {
      for (int i = 0; i < list.length; i++) {
        if (rec[list[i].Date] == null) {
          rec[list[i].Date] = [];
        }

        rec[list[i].Date]!.add(list[i].Name);
      }
      for (var key in rec.keys) {
        tmp.Date = key;
        tmp.member = rec[key]!;
        notices.add(tmp);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initList();
  }

  Widget build(BuildContext context) {
    return gaplist();
  }

  Widget strlist(List<String> s) {
    return Column(
      children: List<Widget>.generate(
        s.length,
        (idx) {
          return ListTile(
            title: Text(
              s[idx],
              style: const TextStyle(
                color: Color.fromARGB(255, 82, 82, 82),
                fontSize: 23.0,
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  Widget gaplist() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: _buildTiles(notices[index]),
      ),
      itemCount: notices.length,
    );
  }

  Widget _buildTiles(datelimit notic) {
    // if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return Card(
      child: ExpansionTile(
        tilePadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        subtitle: Text(
          '共${notic.member.length}筆',
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        leading: const Icon(
          size: 40,
          Icons.warning,
          color: Color.fromARGB(255, 226, 67, 67),
        ),
        key: PageStorageKey<datelimit>(notic),
        title: Text(
          notic.Date,
          style: const TextStyle(
            color: Color.fromARGB(255, 82, 82, 82),
            fontSize: 23.0,
          ),
        ),
        children: [
          strlist(notic.member),
        ],
      ),
    );
  }
}
