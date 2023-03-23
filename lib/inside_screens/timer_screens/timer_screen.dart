import 'dart:math';

import 'package:beemodoro/const/consts.dart';
import 'package:beemodoro/inside_screens/hive/comb_animation/comb_animation.dart';
import 'package:beemodoro/inside_screens/timer_screens/completed_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class TimerScreen extends StatefulWidget {
  int time;
  TimerScreen({super.key, required this.time});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

late CountdownTimerController _controller;

class _TimerScreenState extends State<TimerScreen> {
  bool stop = true;
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * widget.time;
    void onEnd() async {
      FirebaseAuth _auth = FirebaseAuth.instance;
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      var _userDoc = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.email)
          .update({'comb': FieldValue.increment(widget.time / 25 / 60)});
      var _userDocuments = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.email)
          .get();
      if (_userDocuments.data()!['inHive']) {
        var _hiveDoc = await _firestore
            .collection('Hives')
            .doc(_userDocuments.data()!['currentHive'])
            .update({'comb': FieldValue.increment(widget.time / 25 / 60)});
      }
      final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
      // #1
      const androidSetting =
          AndroidInitializationSettings('@mipmap/ic_launcher');

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
                    time: widget.time,
                  )));
    }

    _controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);

    return Scaffold(
      backgroundColor: timerBackgroundColor,
      body: Column(
        children: [
          Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: InkWell(
              radius: 60,
              onTap: () {
                setState(() {
                  stop = !stop;
                });
              },
              child: CircleAvatar(
                radius: 60,
                child:
                    Icon(stop ? FontAwesomeIcons.play : FontAwesomeIcons.pause),
              ),
            ),
          ),
          Spacer(),
          CountdownTimer(
            controller: _controller,
            endTime: endTime,
            onEnd: onEnd,
            widgetBuilder: (context, time) {
              if (time != null) {
                if (time.min != null) {
                  String timeString = timeChanger(time.min.toString()) +
                      ":" +
                      timeChanger(time.sec.toString());
                  return timerWidget(timeString);
                }
                String timeString =
                    "00" + ":" + timeChanger(time.sec.toString());
                return timerWidget(timeString);
              } else {
                return Text("Zaman Doldu");
              }
            },
          ),
          Spacer(),
          Image.asset(beeFlyImage),
        ],
      ),
    );
  }
}

String timeChanger(String? time) {
  if (time != null) {
    if (int.parse(time) < 10) {
      return "0${time}";
    }
    return time;
  } else {
    return "0";
  }
}

timerWidget(String time) {
  return Center(
      child: SizedBox(
          height: sin(1.04) * 250,
          width: 250,
          child: CombAnimation(
            textColor: white,
            comb: time,
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
