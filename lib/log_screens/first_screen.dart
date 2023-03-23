import 'package:beemodoro/const/consts.dart';
import 'package:beemodoro/log_screens/log_in_screen.dart';
import 'package:beemodoro/log_screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset("assets/login.png",
                    scale: .01, fit: BoxFit.fill),
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      appAd,
                      style: TextStyle(
                          fontFamily: "bold",
                          fontSize: 36,
                          color: mainColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Spacer(
                      flex: 4,
                    ),
                    Expanded(flex: 3, child: Image.asset("assets/icon500.png")),
                    Spacer(
                      flex: 2,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor, foregroundColor: white),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => LogIn()));
                        },
                        child: Text("Giriş Yap")),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: white, foregroundColor: mainColor),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()));
                        },
                        child: Text("Kayıt Ol")),
                    Spacer()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
