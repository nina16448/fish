// ignore: file_names
// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'Globals.dart';

class ChoiceChipDemo extends StatefulWidget {
  @override
  State<ChoiceChipDemo> createState() => _ChoiceChipDemoState();
}

class _ChoiceChipDemoState extends State<ChoiceChipDemo> with RestorationMixin {
  final RestorableIntN _indexSelected = RestorableIntN(null);

  @override
  String get restorationId => 'choice_chip_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_indexSelected, 'choice_chip');
  }

  @override
  void dispose() {
    _indexSelected.dispose();
    super.dispose();
  }

  bool isPressed1 = true;
  bool isPressed2 = true;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ChoiceChip(
          avatar: Icon(
            FontAwesome5.fish,
            size: 30,
            color: (isPressed1)
                ? Color.fromARGB(255, 142, 160, 197)
                : Color.fromARGB(255, 255, 255, 255),
          ),
          label: Text(
            '工作',
            style: TextStyle(
              color: (isPressed1)
                  ? Color.fromARGB(255, 142, 160, 197)
                  : Color.fromARGB(255, 255, 255, 255),
              fontSize: 20.0,
            ),
          ),
          labelPadding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
          backgroundColor: const Color.fromARGB(255, 224, 232, 248),
          selectedColor: const Color.fromARGB(255, 44, 84, 121),
          selected: _indexSelected.value == 0,
          onSelected: (value) {
            setState(() {
              ButtonState = value ? 2 : 0;
              isPressed2 = true;
              isPressed1 = value ? false : true;
              _indexSelected.value = value ? 0 : -1;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          avatar: Icon(
            Icons.local_dining,
            size: 30,
            color: (isPressed2)
                ? Color.fromARGB(255, 142, 160, 197)
                : Color.fromARGB(255, 255, 255, 255),
          ),
          label: Text(
            '用餐',
            style: TextStyle(
              color: (isPressed2)
                  ? Color.fromARGB(255, 142, 160, 197)
                  : Color.fromARGB(255, 255, 255, 255),
              fontSize: 20.0,
            ),
          ),
          labelPadding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
          backgroundColor: const Color.fromARGB(255, 224, 232, 248),
          selectedColor: const Color.fromARGB(255, 44, 84, 121),
          selected: _indexSelected.value == 1,
          onSelected: (value) {
            setState(() {
              ButtonState = value ? 1 : 0;
              isPressed1 = true;
              isPressed2 = value ? false : true;
              _indexSelected.value = value ? 1 : -1;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}
