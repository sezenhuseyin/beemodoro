import 'package:beemodoro/const/consts.dart';
import 'package:beemodoro/inside_screens/hive/create_hive.dart';
import 'package:beemodoro/inside_screens/hive/search_hive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoHive extends StatelessWidget {
  const NoHive({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 150,
      child: Column(
        children: [
          Spacer(
            flex: 2,
          ),
          Expanded(
              flex: 3,
              child: Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Image.asset("assets/noBeeHive.png"))),
          SizedBox(
            height: 10,
          ),
          Text(
            "Bir kovanda değilsiniz\nBir kovan oluşturabilirsiniz veya mevcut kovanlara girebilirsiniz",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "bold", fontSize: 22),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: "search",
                backgroundColor: mainColor,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchHive()));
                },
                child: Icon(FontAwesomeIcons.magnifyingGlass),
              ),
              SizedBox(
                width: 20,
              ),
              FloatingActionButton(
                heroTag: "add",
                backgroundColor: mainColor,
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return Center(child: CreateHive());
                    },
                  );
                },
                child: Icon(FontAwesomeIcons.plus),
              ),
              SizedBox(
                width: 20,
              )
            ],
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
