import 'dart:async';

import 'package:beemodoro/const/consts.dart';
import 'package:beemodoro/inside_screens/timer_screens/clock_page.dart';
import 'package:beemodoro/inside_screens/timer_screens/completed_screen.dart';
import 'package:beemodoro/inside_screens/main_screen.dart';
import 'package:beemodoro/inside_screens/timer_screens/set_timer.dart';
import 'package:beemodoro/inside_screens/timer_screens/timer_screen.dart';
import 'package:beemodoro/log_screens/first_screen.dart';
import 'package:beemodoro/log_screens/intro_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configure();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    Firebase.initializeApp();

    return MaterialApp(
        builder: EasyLoading.init(),
        theme: ThemeData(
            inputDecorationTheme: InputDecorationTheme(
              focusColor: white,
              border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(36),
                  borderSide: BorderSide.none),
              focusedBorder: InputBorder.none,
              fillColor: grey,
              filled: true,
              hintStyle: TextStyle(
                fontFamily: "bold",
              ),
              labelStyle: TextStyle(
                fontFamily: "bold",
              ),
            ),
            appBarTheme: AppBarTheme(
                centerTitle: true,
                color: mainColor,
                foregroundColor: white,
                titleTextStyle: TextStyle(fontFamily: "bold", fontSize: 22)),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    minimumSize: Size(300, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36))))),
        debugShowCheckedModeBanner: false,
        title: appAd,
        home: _auth.currentUser != null ? MainScreen() : IntroductionScreen());
  }
}

configure() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
