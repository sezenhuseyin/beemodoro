import 'dart:async';

import 'package:beemodoro/const/consts.dart';
import 'package:beemodoro/inside_screens/hive/comb_animation/comb_animation.dart';
import 'package:beemodoro/inside_screens/timer_screens/completed_screen.dart';
import 'package:beemodoro/inside_screens/timer_screens/wheel.dart';
import 'package:beemodoro/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class ClockPage extends StatefulWidget {
  @override
  _ClockPageState createState() => _ClockPageState();
}

final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

class _ClockPageState extends State<ClockPage> {
  late FixedExtentScrollController _controller;
  int selectedNumber = 25;
  int seconds = 60;
  Timer? timer;
  int minutes = 25;
  bool isPaused = true;
  ScrollPhysics physics = FixedExtentScrollPhysics();
  int secondsLeft = 1;
  int secondsSumCountDown = 1;
  int listViewItemPosition = 24;
  double progress = 1;
  bool isCountdownStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(
      initialItem: 24,
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Spacer(),
            SizedBox(
                height: 250 * 0.86602540378,
                width: 250,
                child:
                    CombAnimation(comb: displayTime(), textColor: mainColor)),
            /*Text(
              displayTime(),
              style: TextStyle(
                fontSize: 80.0,
              ),
            ),*/
            Spacer(),
            GestureDetector(
              onTap: () {
                onListWheelTap();
              },
              child: isPaused
                  ? Container(
                      height: 200.0,
                      width: 600.0,
                      child: NotificationListener<UserScrollNotification>(
                        onNotification: (notification) {
                          physics = FixedExtentScrollPhysics();
                          if (timer != null) {
                            timer!.cancel();
                            minutes = selectedNumber;
                            seconds = 0;
                            reloadCircularProgressIndicator();
                            secondsSumCountDown = 1;
                            secondsLeft = secondsSumCountDown;
                            isCountdownStarted = false;
                            setState(() {
                              isPaused = true;
                            });
                          }
                          return true;
                        },
                        child: ListWheelScrollViewX(
                          scrollDirection: Axis.horizontal,
                          physics: physics,
                          controller: _controller,
                          itemExtent: 40,
                          onSelectedItemChanged: (value) {
                            setState(() {
                              selectedNumber = (value + 1) % 60;
                              minutes = (value + 1) % 60;
                              listViewItemPosition = value;
                            });
                          },
                          builder: (context, index) {
                            index = (index + 1) % 60;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: index % 5 == 0 ? 90.0 : 30,
                                  width: 3.0,
                                  color: yellow,
                                ),
                                Text(
                                  index % 5 == 0 ? index.abs().toString() : '',
                                  style: TextStyle(
                                    fontSize: 30.0,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 200.0,
                      width: 600.0,
                    ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 100,
              width: 100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 2,
                    color: mainColor,
                  ),
                  IconButton(
                    iconSize: 40,
                    icon: isPaused
                        ? Icon(FontAwesomeIcons.play)
                        : Icon(FontAwesomeIcons.pause),
                    onPressed: () {
                      onListWheelTap();
                    },
                  ),
                ],
              ),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }

  void onListWheelTap() {
    if (timer != null) {
      timer!.cancel();
    }
    if (isPaused == false) {
      setState(() {
        isPaused = true;
      });
    } else {
      physics = AlwaysScrollableScrollPhysics();
      startTimer(seconds, minutes);
      turnTheClock();
      setState(() {
        isPaused = false;
      });
    }
  }

  String displayTime() {
    //
    if (seconds == 60) {
      return '$minutes:00';
    } else if (minutes < 10 && seconds < 10) {
      return '0$minutes:0$seconds';
    } else if (minutes < 10 && seconds > 9) {
      return '0$minutes:$seconds';
    } else if (minutes > 9 && seconds < 10) {
      return '$minutes:0$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }

  //
  void turnTheClock() {
    _controller.animateToItem((listViewItemPosition - selectedNumber),
        duration: Duration(
          minutes: selectedNumber,
        ),
        curve: Curves.linear);
  }

  void startTimer(int secondCount, int minutesCount) {
    minutes = minutesCount;
    seconds = secondCount;
    if (!isCountdownStarted) {
      secondsSumCountDown = minutes * 60;
      secondsLeft = secondsSumCountDown;
    }

    isCountdownStarted = true;

    if (timer != null) {
      timer!.cancel();
    }

    if (secondsSumCountDown != 0) {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        bool lastSecond = false;

        setState(() {
          progress = secondsLeft / secondsSumCountDown;
          if (minutes == 0 && seconds == 0) {
            print(timer.tick);
            onEnd(context, timer.tick - 1);
            timer.cancel();
            reloadCircularProgressIndicator();
            secondsSumCountDown = 1;
            secondsLeft = 1;
          } else if (seconds == 60 || (seconds == 0 && minutes != 0)) {
            minutes--;
            seconds--;
            secondsLeft--;
            lastSecond = true;
          } else if (!lastSecond) {
            seconds--;
            secondsLeft--;
          }
          seconds = (seconds) % 60;
        });
      });
    } else {
      secondsSumCountDown = 1;
      secondsLeft = 1;
    }
  }

  void reloadCircularProgressIndicator() {
    progress = secondsLeft / secondsSumCountDown;
    double increment = 0.001;
    timer = Timer.periodic(Duration(microseconds: 1), (timer) {
      setState(() {
        if (progress < 1.0) {
          increment += 0.0001;
          progress += increment;
        } else {
          timer.cancel();
        }
      });
    });
  }
}

onEnd(BuildContext context, int time) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var _userDoc = await _firestore
      .collection('Users')
      .doc(_auth.currentUser!.email)
      .update({'comb': FieldValue.increment(time / 25 / 60)});
  var _userDocuments =
      await _firestore.collection('Users').doc(_auth.currentUser!.email).get();
  if (_userDocuments.data()!['inHive']) {
    var _hiveDoc = await _firestore
        .collection('Hives')
        .doc(_userDocuments.data()!['currentHive'])
        .update({'comb': FieldValue.increment(time / 25 / 60)});
  }
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
  _configure();
  notification(100);
  FlutterRingtonePlayer.play(
      fromAsset: "assets/cool_notif.wav", volume: 1, asAlarm: true);
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => CompletedScreen(
                time: time,
              )));
}

notification(int endTime) async {
  // #1
  tzData.initializeTimeZones();
  final scheduleTime = tz.TZDateTime.fromMillisecondsSinceEpoch(
      tz.local, DateTime.now().millisecondsSinceEpoch + endTime);

// #2
  final androidDetail = AndroidNotificationDetails(
      "channel", // channel Id
      "channel" // channel Name
      );

  final noticeDetail = NotificationDetails(
    android: androidDetail,
  );

// #3
  final id = 0;

// #4
  await _localNotificationsPlugin.zonedSchedule(
    id,
    "Zaman doldu",
    "Biraz mola ver",
    scheduleTime,
    noticeDetail,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    androidAllowWhileIdle: true,
  );
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
