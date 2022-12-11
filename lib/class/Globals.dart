library my_prj.globals;

import '../database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

dynamic pageButtonState = -1;
bool confirmCheckState = false;

int ButtonState = -1;
bool checkState = false;

DateTime currentTime = DateTime.now();
DateTime aTime = DateTime.now();
int prev = 1000;
bool idRight = true;
bool passRight = true;
Namelist now_login = Namelist('');

class Timelist {
  Timelist(
    this.state,
    this.stTime,
    this.endTime,
  );
  int state; // 0是吃飯，1是工作
  DateTime stTime;
  DateTime endTime;
}

///範例///
List<Timelist> getunconfirmed() {
  return [
    Timelist(1, DateTime.utc(2022, 11, 28, 06, 00),
        DateTime.utc(2022, 11, 28, 7, 0)),
    Timelist(
        0, DateTime.utc(2022, 11, 28, 7, 0), DateTime.utc(2022, 11, 28, 7, 30)),
    Timelist(
        1, DateTime.utc(2022, 11, 28, 7, 30), DateTime.utc(2022, 11, 28, 8, 0)),
    Timelist(1, DateTime.utc(2022, 11, 28, 11, 0),
        DateTime.utc(2022, 11, 28, 12, 0)),
    Timelist(0, DateTime.utc(2022, 11, 28, 12, 0),
        DateTime.utc(2022, 11, 28, 12, 30)),
    Timelist(1, DateTime.utc(2022, 11, 28, 12, 30),
        DateTime.utc(2022, 11, 28, 13, 0)),
    Timelist(1, DateTime.utc(2022, 11, 28, 16, 0),
        DateTime.utc(2022, 11, 28, 17, 0)),
    Timelist(0, DateTime.utc(2022, 11, 28, 17, 0),
        DateTime.utc(2022, 11, 28, 17, 30)),
    Timelist(1, DateTime.utc(2022, 11, 28, 17, 30),
        DateTime.utc(2022, 11, 28, 18, 0)),
  ];
}

class Namelist {
  Namelist(this.title, [this.isExpanded = false]);
  String title;
  // String body;
  bool isExpanded;
}

// List<Namelist> getList() {
//   return [
//     Namelist('徐濤'),
//     Namelist('趙福忠'),
//     Namelist('李建偉'),
//     Namelist('任海超'),
//     Namelist('鮑景利'),
//     Namelist('MAS MUKTIADI'),
//     Namelist('ARIKURNIA WAN'),
//     Namelist('ERIAWAN'),
//   ];
// }

// List<Namelist> globalList = [
//   Namelist('徐濤'),
//   Namelist('趙福忠'),
//   Namelist('李建偉'),
//   Namelist('任海超'),
//   Namelist('鮑景利'),
//   Namelist('MAS MUKTIADI'),
//   Namelist('ARIKURNIA WAN'),
//   Namelist('ERIAWAN'),
// ];

// Namelist turnString(String s) {
//   return Namelist(s);
// }
Future<Database> Crewdb = CrewDB.getDB();

class fisherdata {
  fisherdata(
    this.name,
    this.iD,
    this.pW,
    this.workspace,
  );
  String name;
  String iD;
  String pW;
  String workspace;
}
