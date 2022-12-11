import 'dart:math';
import 'package:animations/animations.dart';
import '../database/database.dart';
import 'package:flutter/material.dart';
import 'RecTable.dart';
import 'Globals.dart';

class Steps extends StatefulWidget {
  const Steps({required this.namelist, Key? key}) : super(key: key);
  final List<Member> namelist;

  @override
  State<Steps> createState() => _StepsState();
}

class _StepsState extends State<Steps> {
  @override
  Widget build(BuildContext context) {
    return gaplist();
  }

  Widget gaplist() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0, right: 10, bottom: 50),
      itemBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: _buildTiles(widget.namelist[index]),
      ),
      itemCount: widget.namelist.length,
    );
  }

  Widget _buildTiles(Member root) {
    return Card(
      child: ExpansionTile(
        leading: const Icon(
          Icons.anchor,
          color: Color.fromARGB(255, 142, 160, 197),
        ),
        key: PageStorageKey<Member>(root),
        title: Text(
          root.Name,
          style: const TextStyle(
            color: Color.fromARGB(255, 82, 82, 82),
            fontSize: 20.0,
          ),
        ),
        children: const [MyTable()],
      ),
    );
  }
}
