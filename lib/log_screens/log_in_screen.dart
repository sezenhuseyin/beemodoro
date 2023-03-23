import 'package:beemodoro/const/consts.dart';
import 'package:beemodoro/inside_screens/main_screen.dart';
import 'package:beemodoro/inside_screens/timer_screens/timer_screen.dart';
import 'package:beemodoro/log_screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

bool obsecureText = true;
TextEditingController mailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class _LogInState extends State<LogIn> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obsecureText = true;

    mailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  "assets/login.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BackButton(color: white),
                    ),
                    Spacer(
                      flex: 4,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Giriş Yap",
                          style: TextStyle(fontFamily: "bold", fontSize: 36),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Kovanınla birlikte \nDers çalışmaya başla",
                          style: TextStyle(
                              fontFamily: "bold",
                              fontWeight: FontWeight.bold,
                              color: mainColor.withOpacity(.9),
                              fontSize: 22),
                        )),
                    Spacer(
                      flex: 2,
                    ),
                    TextField(
                        controller: mailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(hintText: "E-mail")),
                    SizedBox(
                      height: 40,
                    ),
                    TextField(
                      obscureText: obsecureText,
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obsecureText = !obsecureText;
                                });
                              },
                              icon: obsecureText
                                  ? Icon(FontAwesomeIcons.solidEye)
                                  : Icon(FontAwesomeIcons.solidEyeSlash)),
                          hintText: "Şifre"),
                    ),
                    /*   Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {}, child: Text("Şifremi Unuttum"))),*/
                    Spacer(
                      flex: 4,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (!mailController.text.isEmpty &&
                              !passwordController.text.isEmpty) {
                            _logIn(
                                mailController.text, passwordController.text);
                          } else {
                            EasyLoading.showToast("Mail veya Şifre eksik");
                          }
                        },
                        child: Text("Giriş Yap")),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Hesabınız yok mu?"),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Register()));
                            },
                            child: Text("Kayıt Ol"))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                      ) ,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _logIn(String email, String password) async {
    try {
      
      FirebaseAuth auth = FirebaseAuth.instance;
      auth
          .signInWithEmailAndPassword(email: email, password: password)
          .whenComplete(() => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(
                        index: 1,
                      ))));
    } on FirebaseAuthException catch (e) {
      EasyLoading.showToast(e.toString());
    }
  }
}
