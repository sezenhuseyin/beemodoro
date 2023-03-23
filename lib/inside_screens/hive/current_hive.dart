import 'dart:math';

import 'package:beemodoro/const/consts.dart';
import 'package:beemodoro/inside_screens/hive/comb_animation/comb_animation.dart';
import 'package:beemodoro/inside_screens/hive/hive_requests.dart';
import 'package:beemodoro/inside_screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CurrentHive extends StatefulWidget {
  final String hiveName;
  CurrentHive({super.key, required this.hiveName});

  @override
  State<CurrentHive> createState() => _CurrentHiveState();
}

class _CurrentHiveState extends State<CurrentHive> {
  @override
  Widget build(BuildContext context) {
    Future<InHiveData> _fetchedData = fetchData(widget.hiveName);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: FutureBuilder<InHiveData>(
          future: _fetchedData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: FloatingActionButton(
                            backgroundColor: red,
                            child: Icon(FontAwesomeIcons.xmark),
                            onPressed: () {
                              quitPopUp(context, snapshot);
                            })),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.hiveName.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: "bold", fontSize: 28),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        snapshot.data!.description,
                        style: TextStyle(fontFamily: "normal", fontSize: 18),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Tooltip(
                        message:
                            "Kovanınızdaki arıların çalıştığı 25 dakikalık zaman dilimleri",
                        child: SizedBox(
                            height: 150 * sin(1.04719),
                            width: 150,
                            child: CombAnimation(
                              comb: snapshot.data!.comb.toStringAsFixed(1),
                              textColor: mainColor,
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Arılar ",
                                    style: TextStyle(
                                        fontFamily: "bold", fontSize: 22),
                                  ))),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HiveRequests(
                                              name: snapshot.data!.name,
                                              requests: snapshot.data!.requests,
                                            )));
                              },
                              icon: Icon(
                                FontAwesomeIcons.circlePlus,
                                color: green,
                                size: 28,
                              )),
                          Text("(" +
                              snapshot.data!.requests.length.toString() +
                              ")"),
                        ],
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        decoration: BoxDecoration(
                            color: grey,
                            borderRadius: BorderRadius.circular(36)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        snapshot.data!.bees.length.toString(),
                                        style: TextStyle(
                                            fontFamily: "bold", fontSize: 18),
                                      ),
                                      Text(" Arı")
                                    ],
                                  )),
                            ),
                            SizedBox(
                              height: 300,
                              child: ListView.builder(
                                  itemCount: snapshot.data!.bees.length,
                                  itemBuilder: (context, int index) {
                                    String text =
                                        snapshot.data!.bees[index].toString();
                                    return ListTile(
                                      title: Center(
                                        child: Text(
                                          text.substring(0, text.indexOf('@')),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: "normal"),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else
              return CircularProgressIndicator();
          },
        )),
      ),
    );
  }

  Future<void> quitPopUp(
      BuildContext context, AsyncSnapshot<InHiveData> snapshot) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: grey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          titlePadding:
              EdgeInsets.only(right: 20, left: 20, top: 40, bottom: 20),
          title: Center(
              child: const Text(
            'Kovandan ayrılıyorsunuz',
            style: TextStyle(fontSize: 22),
          )),
          actionsPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: red),
                  onPressed: () async {
                    FirebaseAuth _auth = FirebaseAuth.instance;

                    FirebaseFirestore _firestore = FirebaseFirestore.instance;
                    _firestore
                        .collection("Users")
                        .doc(_auth.currentUser!.email)
                        .update({'inHive': false, "currentHive": ""});
                    _firestore
                        .collection('Hives')
                        .doc(snapshot.data!.name)
                        .update({
                      'bees': FieldValue.arrayRemove([_auth.currentUser!.email])
                    });
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MainScreen()));
                  },
                  child: Text(
                    "Ayrıl",
                    style: TextStyle(fontFamily: "bold", fontSize: 14),
                  )),
            )
          ],
        );
      },
    );
  }
}

Future<InHiveData> fetchData(String hiveName) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var _userDocuments = await _firestore.collection('Hives').doc(hiveName).get();
  var data = _userDocuments.data()!;
  return InHiveData(
    name: data['name'],
    description: data['description'],
    requests: data['requests'],
    bees: data['bees'],
    comb: double.parse(data['comb'].toString()),
  );
}

class InHiveData {
  final String name;
  final String description;
  final double comb;
  final List<dynamic> bees;
  final List<dynamic> requests;
  InHiveData(
      {required this.name,
      required this.description,
      required this.comb,
      required this.bees,
      required this.requests});
}
