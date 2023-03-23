import 'package:beemodoro/const/consts.dart';
import 'package:beemodoro/inside_screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CreateHive extends StatefulWidget {
  CreateHive({super.key});

  @override
  State<CreateHive> createState() => _CreateHiveState();
}

TextEditingController _titleController = TextEditingController();
TextEditingController _descriptionController = TextEditingController();

class _CreateHiveState extends State<CreateHive> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: white,
      title: Center(
          child: Text(
        "Kovan Oluştur",
        style: TextStyle(fontFamily: "bold"),
      )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              onChanged: (value) {
                setState(() {});
              },
              controller: _titleController,
              decoration: InputDecoration(label: Text("Kovan adı"))),
          SizedBox(
            height: 10,
          ),
          TextField(
              onChanged: (value) {
                setState(() {});
              },
              controller: _descriptionController,
              decoration: InputDecoration(label: Text("Kovan açıklaması")))
        ],
      ),
      actions: [
        ElevatedButton(
            onPressed: _titleController.text.isEmpty ||
                    _descriptionController.text.isEmpty
                ? null
                : () {
                    veriOkuOneTime(
                        _titleController.text, _descriptionController.text);
                  },
            child: Text("Oluştur"))
      ],
      actionsPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
    );
  }

  veriOkuOneTime(String title, String description) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    var _userDocuments = await _firestore.collection('Hives').get();
    var dataList = await _userDocuments.docs;
    bool isValid = false;
    for (var element in _userDocuments.docs) {
      if (element.id == title) {
        isValid = true;
        break;
      } else {
        continue;
      }
    }
    if (!isValid) {
      FirebaseAuth _auth = FirebaseAuth.instance;
      var _userDocuments = await _firestore.collection('Hives').doc(title).set({
        'bees': [_auth.currentUser!.email],
        'name': title,
        'description': description,
        'requests': [],
        'comb': 0
      });
      var _userDoc = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.email)
          .update({'currentHive': title, 'inHive': true});
    }
    Navigator.pop(context);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainScreen()));
  }
}

class Hives {
  final String name;

  const Hives({
    required this.name,
  });

  factory Hives.fromJson(Map<String, dynamic> json) {
    return Hives(
      name: json['name'] as String,
    );
  }
}
