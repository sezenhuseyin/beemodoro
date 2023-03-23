import 'package:beemodoro/const/consts.dart';
import 'package:beemodoro/inside_screens/hive/hive_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchHive extends StatefulWidget {
  const SearchHive({super.key});

  @override
  State<SearchHive> createState() => _SearchHiveState();
}

late Future<List<Hives>> list;
TextEditingController _queryController = TextEditingController();

class _SearchHiveState extends State<SearchHive> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _queryController.clear();
  }

  @override
  Widget build(BuildContext context) {
    list = veriOkuOneTime();

    return Scaffold(
      appBar: AppBar(title: Text("Kovan Bul")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(label: Text("Ara")),
              controller: _queryController,
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: FutureBuilder<List<Hives>>(
                  future: list,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (_queryController.text == "") {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, int index) {
                              return hiveWidget(snapshot.data![index].name,
                                  snapshot.data![index].description);
                            });
                      } else {
                        List<Hives> queryList = snapshot.data!
                            .where((element) => element.name
                                .toLowerCase()
                                .contains(_queryController.text.toLowerCase()))
                            .toList();
                        return ListView.builder(
                            itemCount: queryList.length,
                            itemBuilder: (context, int index) {
                              return hiveWidget(queryList[index].name,
                                  queryList[index].description);
                            });
                      }
                    } else
                      return SizedBox();
                  },
                ))
          ],
        ),
      ),
    );
  }
}

class Hives {
  final String name;
  final String description;

  const Hives({
    required this.name,
    required this.description,
  });

  factory Hives.fromJson(Map<String, dynamic> json) {
    return Hives(
        name: json['name'] as String,
        description: json['description'] as String);
  }
}

Future<List<Hives>> veriOkuOneTime() async {
  List<Hives> list = [];
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var _userDocuments = await _firestore.collection('Hives').get();
  for (var eleman in _userDocuments.docs) {
    Map userMap = eleman.data();
    list.add(Hives(name: userMap['name'], description: userMap['description']));
  }
  return list;
}

hiveWidget(String title, String subtitle) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    child: ListTile(
      tileColor: grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        title,
        style: TextStyle(fontFamily: "bold"),
      ),
      subtitle: Text(subtitle),
      trailing: IconButton(
        icon: Icon(FontAwesomeIcons.plus),
        onPressed: () {
          _request(title);
        },
      ),
    ),
  );
}

_request(String title) async {
  try {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    var _userDocuments = await _firestore.collection('Hives').doc(title);
    FirebaseAuth _auth = FirebaseAuth.instance;
    var data = await _userDocuments.update(
      {
        'requests': FieldValue.arrayUnion([_auth.currentUser!.email])
      },
    );
    EasyLoading.showToast("İstek Gönderildi");
  } catch (e) {
    EasyLoading.showError(e.toString());
  }
}
