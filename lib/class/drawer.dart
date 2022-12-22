import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:page_transition/page_transition.dart';
import 'Globals.dart';
import '../time.dart';
import '../Captain_Home.dart';
import '../PersonnelManagement.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({
    super.key,
    required this.state,
  });
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final int state;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400,
        child: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(
                width: 800,
                height: 150.0,
                child: DrawerHeader(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15.0),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/images/fish.jpg'),
                    fit: BoxFit.cover,
                  )
                      // color: Colors.white,
                      ),
                  child: Text(
                    '選單',
                    // textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          selectedColor: const Color.fromARGB(255, 81, 105, 162),
                          trailing: Icon(
                            Icons.last_page,
                            size: 30,
                            color: (state == 0) ? Color.fromARGB(255, 81, 105, 162) : Color.fromARGB(0, 255, 255, 255),
                          ),
                          selected: (state == 0),
                          leading: const Icon(
                            Icons.edit_document,
                            size: 30,
                          ),
                          title: Text(
                            '工時登記',
                            style: TextStyle(color: (state == 0) ? Color.fromARGB(255, 81, 105, 162) : Color.fromARGB(255, 88, 88, 88), fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            if (state == 0) {
                              Navigator.pop(context);
                            } else {
                              Navigator.popAndPushNamed(context, '/Captain_Home');
                            }
                          },
                        ),
                        ListTile(
                          selectedColor: const Color.fromARGB(255, 81, 105, 162),
                          trailing: (noticelimit == false)
                              ? Icon(
                                  Icons.last_page,
                                  color: (state == 1) ? Color.fromARGB(255, 81, 105, 162) : Color.fromARGB(0, 255, 255, 255),
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.report,
                                  color: Color.fromARGB(255, 255, 89, 89),
                                  size: 30,
                                ),
                          selected: (state == 1),
                          leading: Icon(
                            Icons.notifications_active,
                            size: 30,
                            color: (noticelimit == true)
                                ? Color.fromARGB(255, 255, 225, 89)
                                : (state == 1)
                                    ? Color.fromARGB(255, 81, 105, 162)
                                    : Color.fromARGB(255, 139, 139, 139),
                          ),
                          title: Text(
                            '超時紀錄',
                            style: TextStyle(color: (state == 1) ? Color.fromARGB(255, 81, 105, 162) : Color.fromARGB(255, 88, 88, 88), fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            noticelimit = false;
                            if (state == 1) {
                              Navigator.pop(context);
                            } else {
                              Navigator.popAndPushNamed(context, '/time');
                            }
                          },
                        ),
                        ListTile(
                          selectedColor: const Color.fromARGB(255, 81, 105, 162),
                          trailing: Icon(
                            Icons.last_page,
                            color: (state == 2) ? Color.fromARGB(255, 81, 105, 162) : Color.fromARGB(0, 255, 255, 255),
                            size: 30,
                          ),
                          selected: (state == 2),
                          leading: const Icon(
                            Icons.manage_accounts,
                            size: 30,
                          ),
                          title: Text(
                            '人員管理',
                            style: TextStyle(color: (state == 2) ? Color.fromARGB(255, 81, 105, 162) : Color.fromARGB(255, 88, 88, 88), fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            if (state == 2) {
                              Navigator.pop(context);
                            } else {
                              Navigator.popAndPushNamed(context, '/Management');
                            }
                          },
                        ),
                      ],
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.logout,
                        size: 30,
                      ),
                      title: const Text(
                        '登出系統',
                        style: TextStyle(color: Color.fromARGB(255, 88, 88, 88), fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                        // Navigator.popAndPushNamed(context, '/');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          // ),
        ));
  }
}
