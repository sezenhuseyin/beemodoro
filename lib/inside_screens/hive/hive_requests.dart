import 'package:beemodoro/const/consts.dart';
import 'package:beemodoro/inside_screens/hive/current_hive.dart';
import 'package:beemodoro/inside_screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HiveRequests extends StatefulWidget {
  final String name;
  List<dynamic> requests;
  HiveRequests({super.key, required this.name, required this.requests});

  @override
  State<HiveRequests> createState() => _HiveRequestsState();
}

late Future<List<InHiveData>> list;

class _HiveRequestsState extends State<HiveRequests> {
  @override
  Widget build(BuildContext context) {
    list = fetchData(widget.name);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.chevronLeft),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MainScreen()));
            },
          ),
          title: Text("${widget.name} istekleri")),
      body: FutureBuilder<List<InHiveData>>(
          future: list,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, int index) {
                    print(snapshot.data);
                    return Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        tileColor: grey,
                        title: Text(snapshot.data![index].name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  _accept(
                                      widget.name, snapshot.data![index].name);
                                  setState(() {
                                    widget.requests
                                        .remove(snapshot.data![index].name);
                                  });
                                },
                                icon: Icon(
                                  FontAwesomeIcons.solidCircleCheck,
                                  color: green,
                                  size: 40,
                                )),
                            IconButton(
                                onPressed: () {
                                  _decline(
                                      widget.name, snapshot.data![index].name);
                                  setState(() {
                                    widget.requests
                                        .remove(snapshot.data![index]);
                                  });
                                },
                                icon: Icon(
                                  FontAwesomeIcons.solidCircleXmark,
                                  color: red,
                                  size: 40,
                                )),
                          ],
                        ),
                      ),
                    );
                  });
            } else
              return SizedBox();
          }),
    );
  }

  _accept(String hiveName, String requestName) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.collection('Hives').doc(hiveName).update({
      'requests': FieldValue.arrayRemove([requestName]),
      'bees': FieldValue.arrayUnion([requestName])
    });
    await _firestore
        .collection('Users')
        .doc(requestName)
        .update({'currentHive': hiveName, 'inHive': true});
  }

  _decline(String hiveName, String requestName) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.collection('Hives').doc(hiveName).update({
      'requests': FieldValue.arrayRemove([requestName]),
    });
  }
}

Future<List<InHiveData>> fetchData(String hiveName) async {
  List<InHiveData> newList = [];
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var _userDocuments = await _firestore.collection('Hives').doc(hiveName).get();
  for (var element in _userDocuments['requests']) {
    var _user = await _firestore.collection('Users').doc(element).get();
    if (!_user.data()!['inHive']) {
      newList.add(InHiveData(
        name: _user['mail'],
      ));
    }
  }

  var data = _userDocuments.data()!;
  return newList;
}

class InHiveData {
  final String name;
  InHiveData({required this.name});
}
