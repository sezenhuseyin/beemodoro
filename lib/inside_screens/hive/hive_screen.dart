import 'dart:convert';

import 'package:beemodoro/const/consts.dart';
import 'package:beemodoro/inside_screens/hive/current_hive.dart';
import 'package:beemodoro/inside_screens/hive/no_hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_database/firebase_database.dart';

class Hive extends StatefulWidget {
  Hive({super.key});

  @override
  State<Hive> createState() => _HiveState();
}

late Future<InHiveData> _getData;

class _HiveState extends State<Hive> {
  @override
  Widget build(BuildContext context) {
    _getData = fetchData();
    return Scaffold(
        backgroundColor: white,
        body: FutureBuilder<InHiveData>(
          future: _getData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.inHive
                  ? currentHiveWidget(snapshot: snapshot, widget: widget)
                  : NoHive();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

class currentHiveWidget extends StatelessWidget {
  currentHiveWidget({Key? key, required this.widget, required this.snapshot})
      : super(key: key);
  var snapshot;
  final Hive widget;

  @override
  Widget build(BuildContext context) {
    return CurrentHive(
      hiveName: snapshot.data!.hiveName,
    );
  }
}

Future<InHiveData> fetchData() async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var _userDocuments =
      await _firestore.collection('Users').doc(_auth.currentUser!.email).get();
  return InHiveData(
      inHive: _userDocuments.data()!['inHive'],
      hiveName: _userDocuments.data()!['currentHive']);
}

class InHiveData {
  final bool inHive;
  final String hiveName;
  InHiveData({required this.inHive, required this.hiveName});
}
