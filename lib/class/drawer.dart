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
    return Drawer(
      // child: Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const SizedBox(
            width: 800,
            height: 150.0,
            child: DrawerHeader(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 15.0),
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
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
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
                      trailing: (state == 0)
                          ? const Icon(
                              Icons.last_page,
                              color: Color.fromARGB(255, 81, 105, 162),
                            )
                          : const Icon(
                              Icons.last_page,
                              color: Color.fromARGB(0, 255, 255, 255),
                            ),
                      selected: (state == 0),
                      leading: const Icon(
                        Icons.edit_document,
                      ),
                      title: (state == 0)
                          ? const Text(
                              '工時登記',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 81, 105, 162),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            )
                          : const Text(
                              '工時登記',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 88, 88, 88),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                      onTap: () {
                        // Navigator.popAndPushNamed(context, '/');
                        if (state == 0) {
                          Navigator.pop(context);
                        } else {
                          Navigator.popAndPushNamed(context, '/Captain_Home');
                        }
                      },
                    ),
                    ListTile(
                      selectedColor: const Color.fromARGB(255, 81, 105, 162),
                      trailing: (state == 1)
                          ? const Icon(
                              Icons.last_page,
                              color: Color.fromARGB(255, 81, 105, 162),
                            )
                          : const Icon(
                              Icons.last_page,
                              color: Color.fromARGB(0, 255, 255, 255),
                            ),
                      selected: (state == 1),
                      leading: const Icon(
                        Icons.notifications_active,
                      ),
                      title: (state == 1)
                          ? const Text(
                              '超時紀錄',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 81, 105, 162),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            )
                          : const Text(
                              '超時紀錄',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 88, 88, 88),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                      onTap: () {
                        if (state == 1) {
                          Navigator.pop(context);
                        } else {
                          Navigator.popAndPushNamed(context, '/time');
                        }
                      },
                    ),
                    ListTile(
                      selectedColor: const Color.fromARGB(255, 81, 105, 162),
                      trailing: (state == 2)
                          ? const Icon(
                              Icons.last_page,
                              color: Color.fromARGB(255, 81, 105, 162),
                            )
                          : const Icon(
                              Icons.last_page,
                              color: Color.fromARGB(0, 255, 255, 255),
                            ),
                      selected: (state == 2),
                      leading: const Icon(
                        Icons.manage_accounts,
                      ),
                      title: (state == 2)
                          ? const Text(
                              '人員管理',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 81, 105, 162),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            )
                          : const Text(
                              '人員管理',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 88, 88, 88),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
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
                  leading: Icon(Icons.logout),
                  title: const Text(
                    '登出系統',
                    style: TextStyle(
                        color: Color.fromARGB(255, 88, 88, 88),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      // ),
    );
  }
}
