import 'dart:math';
import 'package:animations/animations.dart';
import '../database/database.dart';
import 'package:flutter/material.dart';
import 'RecTable.dart';
import 'Globals.dart';

class Steps extends StatefulWidget {
  const Steps({required this.namelist, required this.nowlist, Key? key}) : super(key: key);
  final List<Member> namelist;
  final DateTime nowlist;

  @override
  State<Steps> createState() => _StepsState();
}

class _StepsState extends State<Steps> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return gaplist();
  }

  Widget gaplist() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0, right: 10, bottom: 50),
      itemBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
        child: _buildTiles(widget.namelist[index]),
      ),
      itemCount: widget.namelist.length,
    );
  }

  Widget _buildTiles(Member root) {
    return Card(
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        leading: const Icon(
          size: 35,
          Icons.anchor,
          color: Color.fromARGB(255, 142, 160, 197),
        ),
        key: PageStorageKey<Member>(root),
        title: Text(
          root.Name,
          style: const TextStyle(
            color: Color.fromARGB(255, 82, 82, 82),
            fontSize: 24.0,
          ),
        ),
        children: [MyTable(who: root, when: widget.nowlist)],
      ),
    );
  }
}
