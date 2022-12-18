library my_prj.globals;

import '../database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'dart:convert';

dynamic pageButtonState = -1;
bool confirmCheckState = false;

int ButtonState = 0;
bool checkState = false;

var update_queue = Map<String, WorkSheet>();

class Timelist {
  Timelist(
    this.state,
    this.stTime,
    this.endTime,
    this.dura,
  );
  int state; // 0是吃飯，1是工作
  String stTime;
  String endTime;
  double dura;

  Timelist.fromJson(Map<String, dynamic> json)
      : state = json["state"],
        stTime = json["stTime"],
        endTime = json["endTime"],
        dura = json["dura"];

  Map<String, dynamic> toJson() {
    return {
      "state": this.state,
      "stTime": this.stTime,
      "endTime": this.endTime,
      "dura": this.dura,
    };
  }

  @override
  String toString() {
    return "WorkSheet{state: $state, stTime: $stTime, endTime: $endTime, dura: $dura}";
  }
}

DateTime currentTime = DateTime.now();
DateTime aTime = DateTime.now();
int prev = 1000;
bool idRight = true;
bool passRight = true;

Member now_login = Member(
  Id: '',
  Name: '',
  Passwd: '',
  Position: '',
  Wplace: '',
);

List<String> numtoTime = [
  '00:00',
  '00:30',
  '01:00',
  '01:30',
  '02:00',
  '02:30',
  '03:00',
  '03:30',
  '04:00',
  '04:30',
  '05:00',
  '05:30',
  '06:00',
  '06:30',
  '07:00',
  '07:30',
  '08:00',
  '08:30',
  '09:00',
  '09:30',
  '10:00',
  '10:30',
  '11:00',
  '11:30',
  '12:00',
  '12:30',
  '13:00',
  '13:30',
  '14:00',
  '14:30',
  '15:00',
  '15:30',
  '16:00',
  '16:30',
  '17:00',
  '17:30',
  '18:00',
  '18:30',
  '19:00',
  '19:30',
  '20:00',
  '20:30',
  '21:00',
  '21:30',
  '22:00',
  '22:30',
  '23:00',
  '23:30',
  '24:00',
];

///範例///
// List<Timelist> getunconfirmed() {
//   return [
//     Timelist(1, DateTime.utc(2022, 11, 28, 06, 00), DateTime.utc(2022, 11, 28, 7, 0)),
//     Timelist(0, DateTime.utc(2022, 11, 28, 7, 0), DateTime.utc(2022, 11, 28, 7, 30)),
//     Timelist(1, DateTime.utc(2022, 11, 28, 7, 30), DateTime.utc(2022, 11, 28, 8, 0)),
//     Timelist(1, DateTime.utc(2022, 11, 28, 11, 0), DateTime.utc(2022, 11, 28, 12, 0)),
//     Timelist(0, DateTime.utc(2022, 11, 28, 12, 0), DateTime.utc(2022, 11, 28, 12, 30)),
//     Timelist(1, DateTime.utc(2022, 11, 28, 12, 30), DateTime.utc(2022, 11, 28, 13, 0)),
//     Timelist(1, DateTime.utc(2022, 11, 28, 16, 0), DateTime.utc(2022, 11, 28, 17, 0)),
//     Timelist(0, DateTime.utc(2022, 11, 28, 17, 0), DateTime.utc(2022, 11, 28, 17, 30)),
//     Timelist(1, DateTime.utc(2022, 11, 28, 17, 30), DateTime.utc(2022, 11, 28, 18, 0)),
//   ];
// }

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
Future<Database> Sheetdb = SheetDB.getDB();
Future<Database> Warningdb = WarningDB.getDB();
Future<Database> WorkTimedb = WorkTimeDB.getDB();

List<int> initlist() {
  return List<int>.generate(48, (int index) => 0, growable: false);
}

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


class User {
  String user;
  String password;
  List modelData;

  User({
    required this.user,
    required this.password,
    required this.modelData,
  });

  static User fromMap(Map<String, dynamic> user) {
    return new User(
      user: user['user'],
      password: user['password'],
      modelData: jsonDecode(user['model_data']),
    );
  }

  toMap() {
    return {
      'user': user,
      'password': password,
      'model_data': jsonEncode(modelData),
    };
  }
}
