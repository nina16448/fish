import 'dart:collection';
import 'Globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class MyTable extends StatefulWidget {
  const MyTable({super.key});

  @override
  MyTableButtonState createState() => MyTableButtonState();
}

class MyTableButtonState extends State<MyTable> {
  // int? _value = -1;
  List<int> selectedChoices1 = [];
  List<int> selectedChoices2 = [];
  List<int> iconstate =
      List<int>.generate(31, (int index) => 0, growable: false);
  List<int> iconstate_prev =
      List<int>.generate(31, (int index) => 0, growable: false);

  List<int> iconstate2 =
      List<int>.generate(31, (int index) => 0, growable: false);
  List<int> iconstate_prev2 =
      List<int>.generate(31, (int index) => 0, growable: false);

  @override
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
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 105, 117, 143)),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        child: ChoiceChip(
                          backgroundColor:
                              const Color.fromARGB(255, 224, 232, 248),
                          selectedColor: const Color.fromARGB(255, 44, 84, 121),
                          labelPadding: const EdgeInsets.all(6),
                          label: (selectedChoices1.contains(index + ID * 6))
                              ? Icon(
                                  (iconstate[index + ID * 6] == 1)
                                      ? FontAwesome5.fish
                                      : Icons.local_dining,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  size: 30,
                                )
                              : const SizedBox(
                                  height: 50,
                                  width: 50,
                                ),
                          // selected: _value == index,
                          selected: selectedChoices1.contains(index + ID * 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                          onSelected: (bool selected) {
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
                                    '未選擇登記狀態，請選擇工作/用餐',
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
                              backgroundColor:
                                  Color.fromARGB(255, 237, 110, 74),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.all(30),
                              shape: StadiumBorder(),
                              duration: Duration(milliseconds: 800),
                              elevation: 30,
                            );
                            setState(() {
                              if (ButtonState == -1 &&
                                  !selectedChoices1.contains(index + ID * 6)) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                              iconstate[index + ID * 6] = ButtonState;
                              print(index + ID * 6);
                              // selectedChoices.add(index);
                              // selectedChoices.remove(index);
                              print(selectedChoices1.contains(index + ID * 6));

                              selectedChoices1.contains(index + ID * 6)
                                  ? (iconstate[index + ID * 6] == -1)
                                      ? selectedChoices1.remove(index + ID * 6)
                                      : (iconstate_prev[index + ID * 6] ==
                                              iconstate[index + ID * 6])
                                          ? selectedChoices1
                                              .remove(index + ID * 6)
                                          : print('Change mode')
                                  : (iconstate[index + ID * 6] == -1)
                                      ? print('No state')
                                      : selectedChoices1.add(index + ID * 6);
                              iconstate_prev[index + ID * 6] = ButtonState;
                              checkState = (selectedChoices1.length +
                                      selectedChoices2.length >
                                  0);
                              print('state: $checkState');
                              // _value = selected ? index : null;
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
                          selectedColor: const Color.fromARGB(255, 44, 84, 121),
                          labelPadding: const EdgeInsets.all(5),
                          label: (selectedChoices2.contains(index + ID * 6))
                              ? Icon(
                                  (iconstate2[index + ID * 6] == 1)
                                      ? FontAwesome5.fish
                                      : Icons.local_dining,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  size: 30,
                                )
                              : const SizedBox(
                                  height: 50,
                                  width: 50,
                                ),
                          // selected: _value == index,
                          selected: selectedChoices2.contains(index + ID * 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                          onSelected: (bool selected) {
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
                                    '未選擇登記狀態，請選擇工作/用餐',
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
                              backgroundColor:
                                  Color.fromARGB(255, 237, 110, 74),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.all(30),
                              shape: StadiumBorder(),
                              duration: Duration(milliseconds: 800),
                              elevation: 30,
                            );
                            setState(() {
                              if (ButtonState == -1 &&
                                  !selectedChoices2.contains(index + ID * 6)) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                              iconstate2[index + ID * 6] = ButtonState;
                              print(index + ID * 6);
                              // selectedChoices.add(index);
                              // selectedChoices.remove(index);
                              print(selectedChoices2.contains(index + ID * 6));
                              // _value = selected ? index : null;
                              selectedChoices2.contains(index + ID * 6)
                                  ? (iconstate2[index + ID * 6] == -1)
                                      ? selectedChoices2.remove(index + ID * 6)
                                      : (iconstate_prev2[index + ID * 6] ==
                                              iconstate2[index + ID * 6])
                                          ? selectedChoices2
                                              .remove(index + ID * 6)
                                          : print('Change mode')
                                  : (iconstate2[index + ID * 6] == -1)
                                      ? print('No state')
                                      : selectedChoices2.add(index + ID * 6);
                              iconstate_prev2[index + ID * 6] = ButtonState;
                              checkState = (selectedChoices1.length +
                                      selectedChoices2.length >
                                  0);
                              print('state: $checkState');
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
