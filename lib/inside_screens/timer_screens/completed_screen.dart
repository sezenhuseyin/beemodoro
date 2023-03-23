import 'package:beemodoro/const/consts.dart';
import 'package:beemodoro/inside_screens/main_screen.dart';
import 'package:beemodoro/inside_screens/timer_screens/timer_screen.dart';
import 'package:beemodoro/log_screens/first_screen.dart';
import 'package:beemodoro/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CompletedScreen extends StatefulWidget {
  int time;
  CompletedScreen({super.key, required this.time});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  @override
  Widget build(BuildContext context) {
    bool isPressed = false;

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: backgroundColor,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Tamamladın",
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Biraz molayı hak ettin",
                  style: TextStyle(color: white, fontSize: 18),
                ),
                Expanded(
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    alignment:
                        isPressed ? Alignment.topRight : Alignment.center,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(3.1415),
                      child: Image.network(beeGif),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScreen()));
                    },
                    child: Text("Anasayfa")),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
