import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Leadership extends StatelessWidget {
  Leadership({super.key});
  late Future<List<UserData>> bireyselData;
  //late Future<List<HiveData>> hiveData;

  @override
  Widget build(BuildContext context) {
    bireyselData = _getUserData();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Liderlik Sıralamaları"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                "Bireysel",
                style: TextStyle(fontFamily: "bold", fontSize: 22),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                width: MediaQuery.of(context).size.width / 2 - 50,
                child: FutureBuilder<List<UserData>>(
                    future: bireyselData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.length > 5
                                ? 5
                                : snapshot.data!.length,
                            itemBuilder: (context, int index) {
                              return leadershipWidget(
                                  snapshot.data![index].name);
                            });
                      } else {
                        return SizedBox();
                      }
                    }),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "Kovan",
                style: TextStyle(fontFamily: "bold", fontSize: 22),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                width: MediaQuery.of(context).size.width / 2 - 50,
                child: ListView.builder(itemBuilder: (context, int index) {
                  return leadershipWidget("s");
                }),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

leadershipWidget(String name) {
  return Container(
    child: Row(
      children: [
        Icon(FontAwesomeIcons.medal),
        Text(
          name,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Future<List<UserData>> _getUserData() async {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<UserData> list = [];
  var userData = await _firestore.collection('Users').get();
  userData.docs.forEach((element) {
    list.add(
        UserData(comb: double.parse(element['comb'].toString()), name: element['mail']));
  });
  return list;
}

class UserData {
  final String name;
  final double comb;

  const UserData({required this.name, required this.comb});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'] as String,
      comb: double.parse(json['comb']),
    );
  }
}
