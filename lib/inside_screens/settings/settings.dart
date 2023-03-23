import 'dart:async';
import 'dart:io';

import 'package:beemodoro/const/consts.dart';
import 'package:beemodoro/inside_screens/settings/leadership/leadership.dart';
import 'package:beemodoro/log_screens/first_screen.dart';
import 'package:beemodoro/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Future<UserData> _userData;

  @override
  Widget build(BuildContext context) {
    _userData = _getUserData();
    return SafeArea(
      child: FutureBuilder<UserData>(
          future: _userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!;
              return Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      data.name.substring(0, data.name.indexOf("@")),
                      style: TextStyle(fontFamily: "bold", fontSize: 28),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      endIndent: 80,
                      indent: 80,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Biriktirdiği bal peteği",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      data.comb.toStringAsFixed(2),
                      style: TextStyle(fontFamily: "bold", fontSize: 28),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Her 25 dakikalık zaman dilimini gösterir",
                        style: TextStyle(fontFamily: "normal", fontSize: 16)),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      endIndent: 40,
                      indent: 40,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Bulunduğu kovan"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      data.currentHive != "" ? data.currentHive : "yok",
                      style: TextStyle(fontFamily: "bold", fontSize: 22),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    /* OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            foregroundColor: mainColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(36))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Leadership()));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              FontAwesomeIcons.solidFlag,
                              color: yellow,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Liderlik Sıralaması"),
                          ],
                        )),*/
                    Spacer(),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        FirebaseAuth _auth = FirebaseAuth.instance;
                        _auth.signOut();

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FirstScreen()));
                      },
                      child: Text(
                        "Çıkış Yap",
                        style: TextStyle(fontFamily: "bold", fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: red, foregroundColor: white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

Future<UserData> _getUserData() async {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  var userData =
      await _firestore.collection('Users').doc(_auth.currentUser!.email).get();
  return UserData(
      comb: double.parse(userData['comb'].toString()),
      currentHive: userData['currentHive'],
      name: userData['mail']);
}

class UserData {
  final String name;
  final String currentHive;
  final double comb;

  const UserData(
      {required this.name, required this.comb, required this.currentHive});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'] as String,
      currentHive: json['currentHive'],
      comb: double.parse(json['comb']),
    );
  }
}
