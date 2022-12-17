import 'dart:collection';
import 'Globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import '../database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

class MyTable extends StatefulWidget {
  const MyTable({required this.who, required this.when, super.key});
  final Member who;
  final DateTime when;

  @override
  MyTableButtonState createState() => MyTableButtonState();
}

class MyTableButtonState extends State<MyTable> {
  // int? _value = -1;
  // Uint8List nowsheet = Uint8List.fromList(initlist());
  WorkSheet tabledata = WorkSheet(
    SheetId: 0,
    MemberId: '0',
    Date: '0',
    State: 0,
    Sheet: [],
  );
  // List<int> recsheet =

  //     List<int>.generate(31, (int index) => 0, growable: false);

  List<int> selectedChoices = [];

  List<int> iconstate = List<int>.generate(48, (int index) => 0, growable: false);

  List<int> iconstate_prev = List<int>.generate(48, (int index) => 0, growable: false);

  // List<int> iconstate =
  //     List<int>.generate(31, (int index) => 0, growable: false);
  // List<int> iconstate_prev =
  //     List<int>.generate(31, (int index) => 0, growable: false);
  // List<int> selectedChoices = [];

  void initList() async {
    final sheetList = await SheetDB.getsheet(widget.who.Id, formatDate(widget.when, [yyyy, '/', mm, '/', dd]), Sheetdb);

    setState(() {
      debugPrint('Load DATA...');
      if (sheetList.isNotEmpty) {
        debugPrint("Success:D");
        tabledata.State = sheetList[0].State;
        // tabledata = sheetList[0];
        // iconstate = sheetList[0].Sheet;
        for (int i = 0; i < sheetList[0].Sheet.length; i++) {
          iconstate[i] = sheetList[0].Sheet[i];
          if (sheetList[0].Sheet[i] != 0) {
            selectedChoices.add(i);
          }
        }
      } else {
        debugPrint('Data Not found:(');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initList();

    tabledata.SheetId = int.parse('${widget.who.Id}${formatDate(widget.when, [yyyy, mm, dd])}');
    tabledata.MemberId = widget.who.Id;
    tabledata.Date = formatDate(widget.when, [yyyy, '/', mm, '/', dd]);
    debugPrint(tabledata.toString());
  }

  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: _fourTimes(),
      // Column(children: [_row()]),
    );
  }

  Widget _fourTimes() {
    return Column(
      children: List<Widget>.generate(4, (ID) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List<Widget>.generate(
            6,
            (index) {
              return Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 90,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${index + ID * 6}',
                      style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 105, 117, 143)),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        child: ChoiceChip(
                          backgroundColor: const Color.fromARGB(255, 224, 232, 248),
                          selectedColor: (iconstate[(index + ID * 6) * 2] == 2) ? const Color.fromARGB(255, 44, 84, 121) : Color.fromARGB(255, 70, 118, 163),
                          labelPadding: const EdgeInsets.all(6),
                          label: (selectedChoices.contains((index + ID * 6) * 2))
                              ? Icon(
                                  (iconstate[(index + ID * 6) * 2] == 2) ? FontAwesome5.fish : Icons.local_dining,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  size: 30,
                                )
                              : const SizedBox(
                                  height: 50,
                                  width: 50,
                                ),
                          // selected: _value == index,
                          selected: selectedChoices.contains((index + ID * 6) * 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                          onSelected: (bool selected) {
                            var snackBar = SnackBar(
                              content: Row(
                                children: [
                                  const Icon(
                                    Icons.warning,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    (tabledata.State == 0) ? '未選擇登記狀態，請選擇工作/用餐' : '工時已確認，無法進行更動',
                                    style: const TextStyle(
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
                              if (tabledata.State == 0) {
                                //未確認
                                if (ButtonState == 0 && !selectedChoices.contains((index + ID * 6) * 2)) {
                                  //沒有選擇狀態且該項是空的
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                                // iconstate[(index + ID * 6) * 2] = ButtonState;
                                print((index + ID * 6) * 2);
                                debugPrint('${(index + ID * 6) * 2}');
                                // selectedChoices.add(index);
                                // selectedChoices.remove(index);
                                print(selectedChoices.contains((index + ID * 6) * 2));

                                // selectedChoices.contains((index + ID * 6) * 2)
                                //     ? (iconstate[(index + ID * 6) * 2] == 0)
                                //         ? selectedChoices.remove((index + ID * 6) * 2)
                                //         : (iconstate_prev[(index + ID * 6) * 2] == iconstate[(index + ID * 6) * 2])
                                //             ? selectedChoices.remove((index + ID * 6) * 2)
                                //             : print('Change mode')
                                //     : (iconstate[(index + ID * 6) * 2] == 0)
                                //         ? print('No state')
                                //         : selectedChoices.add((index + ID * 6) * 2);
                                if (selectedChoices.contains((index + ID * 6) * 2)) {
                                  if (ButtonState == 0) {
                                    selectedChoices.remove((index + ID * 6) * 2);
                                    iconstate[(index + ID * 6) * 2] = 0;
                                  } else {
                                    if (iconstate_prev[(index + ID * 6) * 2] == ButtonState) {
                                      selectedChoices.remove((index + ID * 6) * 2);
                                      iconstate[(index + ID * 6) * 2] = 0;
                                    } else {
                                      iconstate[(index + ID * 6) * 2] = ButtonState;
                                      print('Change mode');
                                    }
                                  }
                                } else {
                                  if (ButtonState == 0) {
                                    iconstate[(index + ID * 6) * 2] = 0;
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  } else {
                                    iconstate[(index + ID * 6) * 2] = ButtonState;
                                    selectedChoices.add((index + ID * 6) * 2);
                                  }
                                }

                                iconstate_prev[(index + ID * 6) * 2] = iconstate[(index + ID * 6) * 2];
                                checkState = (selectedChoices.isNotEmpty);
                                print('state: $checkState');
                                tabledata.Sheet = iconstate;
                                update_queue[tabledata.MemberId] = tabledata;
                                debugPrint(tabledata.toString());
                                debugPrint(update_queue.toString());
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        child: ChoiceChip(
                          backgroundColor: Color.fromARGB(255, 232, 239, 253),
                          selectedColor: (iconstate[(index + ID * 6) * 2 + 1] == 2) ? const Color.fromARGB(255, 44, 84, 121) : Color.fromARGB(255, 70, 118, 163),
                          labelPadding: const EdgeInsets.all(5),
                          label: (selectedChoices.contains((index + ID * 6) * 2 + 1))
                              ? Icon(
                                  (iconstate[(index + ID * 6) * 2 + 1] == 2) ? FontAwesome5.fish : Icons.local_dining,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  size: 30,
                                )
                              : const SizedBox(
                                  height: 50,
                                  width: 50,
                                ),
                          // selected: _value == index,
                          selected: selectedChoices.contains((index + ID * 6) * 2 + 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                          onSelected: (bool selected) {
                            var snackBar = SnackBar(
                              content: Row(
                                children: [
                                  const Icon(
                                    Icons.warning,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    (tabledata.State == 0) ? '未選擇登記狀態，請選擇工作/用餐' : '已確認工時，無法更動',
                                    style: const TextStyle(
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
                              if (tabledata.State == 0) {
                                print((index + ID * 6) * 2 + 1);
                                print(selectedChoices.contains((index + ID * 6) * 2 + 1));

                                if (selectedChoices.contains((index + ID * 6) * 2 + 1)) {
                                  if (ButtonState == 0) {
                                    selectedChoices.remove((index + ID * 6) * 2 + 1);
                                    iconstate[(index + ID * 6) * 2 + 1] = 0;
                                  } else {
                                    if (iconstate_prev[(index + ID * 6) * 2 + 1] == ButtonState) {
                                      selectedChoices.remove((index + ID * 6) * 2 + 1);
                                      iconstate[(index + ID * 6) * 2 + 1] = 0;
                                    } else {
                                      iconstate[(index + ID * 6) * 2 + 1] = ButtonState;
                                      print('Change mode');
                                    }
                                  }
                                } else {
                                  if (ButtonState == 0) {
                                    iconstate[(index + ID * 6) * 2 + 1] = 0;
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  } else {
                                    iconstate[(index + ID * 6) * 2 + 1] = ButtonState;
                                    selectedChoices.add((index + ID * 6) * 2 + 1);
                                  }
                                }
                                // selectedChoices.contains((index + ID * 6) * 2 + 1)
                                //     ? (iconstate[(index + ID * 6) * 2 + 1] == 0)
                                //         ? selectedChoices.remove((index + ID * 6) * 2 + 1)
                                //         : (iconstate_prev[(index + ID * 6) * 2 + 1] == iconstate[(index + ID * 6) * 2 + 1])
                                //             ? selectedChoices.remove((index + ID * 6) * 2 + 1)
                                //             : print('Change mode')
                                //     : (iconstate[(index + ID * 6) * 2 + 1] == 0)
                                //         ? print('No state')
                                //         : selectedChoices.add((index + ID * 6) * 2 + 1);
                                iconstate_prev[(index + ID * 6) * 2 + 1] = iconstate[(index + ID * 6) * 2 + 1];
                                checkState = (selectedChoices.isNotEmpty);
                                print('state: $checkState');
                                tabledata.Sheet = iconstate;
                                update_queue[tabledata.MemberId] = tabledata;
                                debugPrint(update_queue.toString());
                                debugPrint(tabledata.toString());
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ],
              );
            },
          ).toList(),
        );
      }).toList(),
    );
  }
}
