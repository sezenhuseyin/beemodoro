import 'package:beemodoro/const/consts.dart';
import 'package:beemodoro/log_screens/log_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

bool obsecureText = true;
TextEditingController mailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class _RegisterState extends State<Register> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obsecureText = true;
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
                          "Kayıt Ol",
                          style: TextStyle(fontFamily: "bold", fontSize: 36),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Ders çalışmaya başla",
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
                    Spacer(
                      flex: 4,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (mailController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty) {
                            _register(
                                mailController.text, passwordController.text);
                          } else {
                            EasyLoading.showError("Mail Veya Şifre Eksik");
                          }
                        },
                        child: Text("Kayıt Ol")),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Zaten hesabınız var mı?"),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LogIn()));
                            },
                            child: Text("Giriş Yap"))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _register(String mail, String pass) async {
    try {
      FirebaseAuth auth = await FirebaseAuth.instance;
      auth.createUserWithEmailAndPassword(email: mail, password: pass);
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      WriteBatch _batch = _firestore.batch();
      CollectionReference _counterColRef = _firestore.collection("Users");
      _batch.set(_counterColRef.doc(mail),
          {'comb': 0, 'currentHive': "", 'inHive': false, 'mail': mail});
      await _batch.commit();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LogIn()));
    } on FirebaseAuthException catch (e) {
      return EasyLoading.showError(e.toString());
    } catch (e) {
      return EasyLoading.showError(e.toString());
    }
  }
}
