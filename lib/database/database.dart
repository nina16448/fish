// ignore_for_file: non_constant_identifier_names

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'dart:async';

//成員
class Member {
  String Id;
  String Name;
  String Passwd;
  String Position;
  String Wplace;

  Member({
    required this.Id,
    required this.Name,
    required this.Passwd,
    required this.Position,
    required this.Wplace,
  });
  Map<String, dynamic> toMap() {
    return {
      'Id': Id,
      'Name': Name,
      'Passwd': Passwd,
      'Position': Position,
      'Wplace': Wplace,
    };
  }

  @override
  String toString() {
    return "Member{Id: $Id, Name: $Name, Passwd: $Passwd, Position: $Position, Wplace: $Wplace}";
  }
}

//工作表
class WorkSheet {
  final int SheetId;
  final String MemberId;
  final String Date;
  final Uint8List Sheet;
  WorkSheet(
      {required this.SheetId,
      required this.MemberId,
      required this.Date,
      required this.Sheet});
  Map<String, dynamic> toMap() {
    return {
      'SheetId': SheetId,
      'MemberId': MemberId,
      'Date': Date,
      'Sheet': Sheet,
    };
  }

  @override
  String toString() {
    String Str = Sheet.join(' ');
    return "WorkSheet{SheetId: $SheetId, MemberId: $MemberId, Date: $Date, Sheet: $Str}";
  }
}

class WarningRecord {
  final int recId;
  final String MemberId;
  final String Name;
  final String Date;

  WarningRecord(
      {required this.recId,
      required this.MemberId,
      required this.Name,
      required this.Date});

  Map<String, dynamic> toMap() {
    return {
      'recId': recId,
      'MemberId': MemberId,
      'Name': Name,
      'date': Date,
    };
  }

  @override
  String toString() {
    return "WorkSheet{SheetId: $recId, MemberId: $MemberId, Name: $Name, Date: $Date}";
  }
}

class CrewDB {
  //取得資料庫
  static Future<Database> getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'Crew.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE Member(Id TEXT, Name TEXT, Passwd TEXT, Position TEXT, Wplace TEXT)',
        );
      },
      version: 1,
    );
  }

  // Define a function that inserts dogs into the database
  static Future<void> AddMember(Member member, Future<Database> DB) async {
    final db = await DB;
    await db.insert(
      'Member',
      member.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //取得船員資料，若參數為All，則回傳所有船員資料
  static Future<List<Member>> getMember(Future<Database> DB,
      [String id = 'All', String name = 'none']) async {
    final db = await DB;
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps;

    // if (name != 'none') {
    //   maps = await db.rawQuery('SELECT * FROM Member where Name = ?', [name]);
    // } else
    if (id == 'All') {
      maps = await db.query('Member');
    } else {
      maps = await db.rawQuery('SELECT * FROM Member where Id = ?', [id]);
    }
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Member(
        Id: maps[i]['Id'],
        Name: maps[i]['Name'],
        Passwd: maps[i]['Passwd'],
        Position: maps[i]['Position'],
        Wplace: maps[i]['Wplace'],
      );
    });
  }

  static Future<void> updateMember(Member member, Future<Database> DB) async {
    final Database db = await DB;
    await db.update(
      'Member',
      member.toMap(),
      where: "Id = ?",
      whereArgs: [member.Id],
    );
  }

  static Future<void> deleteMember(String id, Future<Database> DB) async {
    final Database db = await DB;
    await db.delete(
      'Member',
      where: "Id = ?",
      whereArgs: [id],
    );
  }
}

class SheetDB {
  static Future<Database> getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'Sheet.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE WorkSheet(SheetId INT PRIMARY KEY NOT NULL, MemberId TEXT, Date TEXT, Sheet BLOB)',
        );
      },
      version: 1,
    );
  }

  static Future<void> AddWorkTime(WorkSheet sheet, Future<Database> DB) async {
    final db = await DB;
    await db.insert(
      'WorkSheet',
      sheet.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<WorkSheet>> getsheet(
      String id, String date, Future<Database> DB) async {
    final db = await DB;
    final List<Map<String, dynamic>> maps;
    if (id == 'All') {
      maps = await db.rawQuery('SELECT * FROM WorkSheet');
    } else {
      maps = await db.rawQuery(
          'SELECT * FROM WorkSheet WHERE MemberId = ? AND Date = ?',
          [id, date]);
    }
    return List.generate(maps.length, (i) {
      return WorkSheet(
        SheetId: maps[i]['SheetId'],
        MemberId: maps[i]['MemberId'],
        Date: maps[i]['Date'],
        Sheet: maps[i]['Sheet'],
      );
    });
  }

  static Future<void> updateSheet(WorkSheet sheet, Future<Database> DB) async {
    final Database db = await DB;
    await db.update(
      'WorkSheet',
      sheet.toMap(),
      where: "MemberId = ? AND Date = ?",
      whereArgs: [sheet.MemberId, sheet.Date],
    );
  }

  static Future<void> deleteSheet(
      String id, String date, Future<Database> DB) async {
    final Database db = await DB;
    await db.delete(
      'WorkSheet',
      where: "MemberId = ? AND Date = ?",
      whereArgs: [id, date],
    );
  }
}

class WarningDB {
  //取得資料庫
  static Future<Database> getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'Warning.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE WarningRec(recId TEXT PRIMARY KEY, MemberId TEXT, Name TEXT, Date TEXT)',
        );
      },
      version: 1,
    );
  }

  // Define a function that inserts dogs into the database
  static Future<void> Addrecord(WarningRecord rec, Future<Database> DB) async {
    final db = await DB;
    await db.insert(
      'WarningRec',
      rec.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //取得船員資料，若參數為All，則回傳所有船員資料
  static Future<List<WarningRecord>> getRecord(
      String id, Future<Database> DB) async {
    final db = await DB;
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps;
    if (id == 'All') {
      maps = await db.query('WarningRec');
    } else {
      maps = await db.rawQuery('SELECT * FROM WarningRec where Id = ?', [id]);
    }
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return WarningRecord(
        recId: maps[i]['recId'],
        MemberId: maps[i]['MemberId'],
        Name: maps[i]['Name'],
        Date: maps[i]['Date'],
      );
    });
  }

  static Future<void> updateRecord(
      WarningRecord rec, Future<Database> DB) async {
    final Database db = await DB;
    await db.update(
      'WarningRec',
      rec.toMap(),
      where: "Id = ? AND Date = ?",
      whereArgs: [rec.MemberId, rec.Date],
    );
  }

  static Future<void> deleteRecord(
      String id, String date, Future<Database> DB) async {
    final Database db = await DB;
    await db.delete(
      'WarningRec',
      where: "Id = ? AND Date = ?",
      whereArgs: [id, date],
    );
  }
}
