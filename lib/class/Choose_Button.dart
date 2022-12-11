// ignore: file_names
// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
          avatar: isPressed1
              ? const Icon(
                  FontAwesome5Solid.fish,
                  color: Color.fromARGB(255, 142, 160, 197),
                )
              : const Icon(
                  FontAwesome5Solid.fish,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
          label: isPressed1
              ? const Text(
                  '工作',
                  style: TextStyle(
                    color: Color.fromARGB(255, 142, 160, 197),
                    fontSize: 16.0,
                  ),
                )
              : const Text(
                  '工作',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16.0,
                  ),
                ),
          labelPadding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
          backgroundColor: const Color.fromARGB(255, 224, 232, 248),
          selectedColor: const Color.fromARGB(255, 44, 84, 121),
          selected: _indexSelected.value == 0,
          onSelected: (value) {
            setState(() {
              ButtonState = value ? 1 : -1;
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
          avatar: isPressed2
              ? const Icon(
                  Icons.local_dining,
                  color: Color.fromARGB(255, 142, 160, 197),
                )
              : const Icon(
                  Icons.local_dining,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
          label: isPressed2
              ? const Text(
                  '用餐',
                  style: TextStyle(
                    color: Color.fromARGB(255, 142, 160, 197),
                    fontSize: 16.0,
                  ),
                )
              : const Text(
                  '用餐',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16.0,
                  ),
                ),
          labelPadding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
          backgroundColor: const Color.fromARGB(255, 224, 232, 248),
          selectedColor: const Color.fromARGB(255, 44, 84, 121),
          selected: _indexSelected.value == 1,
          onSelected: (value) {
            setState(() {
              ButtonState = value ? 2 : -1;
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
