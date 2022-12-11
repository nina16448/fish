import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'database/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //取得database位置
  Future<Database> Crewdb = CrewDB.getDB();
  Future<Database> Sheetdb = SheetDB.getDB();
  //建立三名員工資料
  var Lee =  Member(
    Id: '0',
    Name: 'Miles',
    Passwd: '1234567',
    Position: 'Captain',
    Wplace: 'Office',
  );
  var Lo =  Member(
    Id: '1',
    Name: '政傑',
    Passwd: '2345678',
    Position: 'fisherman',
    Wplace: 'dock',
  );
  var Zhang =  Member(
    Id: '2',
    Name: '創桓',
    Passwd: '3456789',
    Position: 'fisherman',
    Wplace: 'dock',
  );
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  String now = dateFormat.format(DateTime.now());
  //建立兩筆工作時程表
  final sheet1 = Uint8List.fromList([
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    2,
    2,
    2,
    2,
    2,
    2,
    2,
    2,
    2,
    2,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    4,
    4,
    4,
    4,
    4,
    4,
    4,
    4,
    4,
    4,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5
  ]);
  var Lo_Sheet = WorkSheet(
    SheetId: 1,
    MemberId: '1',
    Date: now,
    Sheet: sheet1,
  );
  String yesterday =
      dateFormat.format(DateTime.now().subtract(Duration(days: 1)));
  final sheet2 = Uint8List.fromList([
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    4,
    4,
    4,
    4,
    4,
    4,
    4,
    4,
    4,
    4,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    2,
    2,
    2,
    2,
    2,
    2,
    2,
    2,
    2,
    2,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1
  ]);
  var Lo_Sheet2 = WorkSheet(
    SheetId: 2,
    MemberId: '1',
    Date: yesterday,
    Sheet: sheet2,
  );
  //新增三名船員
  await CrewDB.AddMember(Lee, Crewdb);
  await CrewDB.AddMember(Lo, Crewdb);
  await CrewDB.AddMember(Zhang, Crewdb);
  //新增兩筆工作時程表
  await SheetDB.AddWorkTime(Lo_Sheet, Sheetdb);
  await SheetDB.AddWorkTime(Lo_Sheet2, Sheetdb);

  //取得所有船員資料
  List<Member> member = await CrewDB.getMember(Crewdb, 'All');
  //取得船員ID為1日期為昨天的工時表
  List<WorkSheet> sheet3 = await SheetDB.getsheet('1', yesterday, Sheetdb);
  debugPrint(member.toString());
  debugPrint(sheet3.toString());
  //刪除ID為1號的船員資料
  await CrewDB.deleteMember('1', Crewdb);
  member = await CrewDB.getMember(Crewdb, 'All');
  debugPrint(member.toString());
  Lee = Member(
    Id: '0',
    Name: '俊佑',
    Passwd: '1234567',
    Position: 'Captain',
    Wplace: 'Office',
  );
  //更新船員0號的資料
  await CrewDB.updateMember(Lee, Crewdb);
  member = await CrewDB.getMember(Crewdb, '0');
  debugPrint(member.toString());
  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
