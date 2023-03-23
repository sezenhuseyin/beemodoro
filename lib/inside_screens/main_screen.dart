import 'package:beemodoro/const/consts.dart';
import 'package:beemodoro/inside_screens/hive/hive_screen.dart';
import 'package:beemodoro/inside_screens/settings/settings.dart';
import 'package:beemodoro/inside_screens/timer_screens/clock_page.dart';
import 'package:beemodoro/inside_screens/timer_screens/set_timer.dart';
import 'package:beemodoro/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

class MainScreen extends StatefulWidget {
  int? index;
  MainScreen({super.key, int? index});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

int _currentIndex = 1;

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {

    getPermission();
    _configure();
    List<Widget> pages = [Hive(), ClockPage()  , SettingsScreen()];

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title:
              SizedBox(height: 50, child: Image.asset("assets/icon500.png"))),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          fixedColor: mainColor,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: IconButton(
                  icon: Icon(FontAwesomeIcons.hive),
                  onPressed: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                ),
                label: "Kovan"),
            BottomNavigationBarItem(
                icon: IconButton(
                  icon: Icon(FontAwesomeIcons.solidClock),
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                ),
                label: "Sayaç"),
            BottomNavigationBarItem(
                icon: IconButton(
                  icon: Icon(FontAwesomeIcons.solidUser),
                  onPressed: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                  },
                ),
                label: "Hesabım"),
          ]),
    );
  }
}

_configure() async {
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // #1
  const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');

  // #2
  const initSettings = InitializationSettings(android: androidSetting);

  // #3
  await _localNotificationsPlugin.initialize(initSettings).then((_) {
    debugPrint('setupPlugin: setup success');
  }).catchError((Object error) {
    debugPrint('Error: $error');
  });
}

getPermission() async {
  bool permission = await Permission.notification.isDenied;
  if (permission) {
    Permission.notification.request();
  }
}
