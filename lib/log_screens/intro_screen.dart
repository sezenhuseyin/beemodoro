import 'package:beemodoro/const/consts.dart';
import 'package:beemodoro/log_screens/first_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

String title = "Ders Çalış";
String subtitle = "Pomodoro tekniğiyle ders çalışarak verimini arttır";

String title2 = "Kovana Katıl";
String subtitle2 =
    "Kovan kur veya kovana katılarak başka arılarla birlikte çalış";

String title3 = "Diğer Kovanlarla Yarış";
String subtitle3 = "Diğer kovanlarla yarış ve en çok bal üreten sen ol";

class _IntroductionScreenState extends State<IntroductionScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  final controller = PageController();
  bool isLast = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/loginbackground.png",
                fit: BoxFit.fill,
              ),
            ),
            Column(
              children: [
                const Spacer(
                  flex: 2,
                ),
                SizedBox(height: 300, child: Image.asset("assets/icon500.png")),
                const Spacer(),
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.only(top: 20, right: 10, left: 10),
                    decoration: BoxDecoration(
                        color: yellow.withOpacity(.9),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(36))),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            title,
                            style: TextStyle(
                                fontFamily: "bold",
                                color: yellow,
                                fontSize: 36),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                              fontFamily: "normal",
                              color: yellow,
                              fontSize: 22),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            PageView(
              onPageChanged: (value) {
                setState(() {
                  isLast = value == 2;
                });
              },
              controller: controller,
              children: [
                _firstPage(),
                _secondPage(),
                _thirdPage(),
              ],
            ),
            isLast
                ? Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: CupertinoButton(
                              color: mainColor,
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FirstScreen()));
                              },
                              child: Center(
                                heightFactor: 1.75,
                                child: Text(
                                  "Başlayalım",
                                  style: TextStyle(
                                      fontFamily: "bold", color: white),
                                ),
                              )),
                        )),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FirstScreen()));
                          },
                          child: Text(
                            "Geç",
                            style: TextStyle(fontFamily: "bold", color: blue),
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(36)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                          margin: EdgeInsets.only(bottom: 20),
                          child: SmoothPageIndicator(
                              onDotClicked: (index) {
                                setState(() {
                                  controller.animateToPage(index,
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.linear);
                                });
                              },
                              effect:
                                  WormEffect(activeDotColor: blue, spacing: 16),
                              controller: controller,
                              count: 3)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: CupertinoButton(
                            color: mainColor,
                            child: Center(
                              child: Text("İlerle"),
                              heightFactor: 1.5,
                            ),
                            onPressed: () {
                              controller.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.linear);
                            }),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _firstPage() {
    return Column(
      children: [
        const Spacer(
          flex: 5,
        ),
        Expanded(
          flex: 3,
          child: Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    title,
                    style: TextStyle(
                        fontFamily: "bold", color: white, fontSize: 36),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                      fontFamily: "normal", color: white, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _secondPage() {
    return Column(
      children: [
        const Spacer(
          flex: 5,
        ),
        Expanded(
          flex: 3,
          child: Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    title2,
                    style: TextStyle(
                        fontFamily: "bold", color: white, fontSize: 36),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  subtitle2,
                  style: TextStyle(
                      fontFamily: "normal", color: white, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _thirdPage() {
    return Column(
      children: [
        const Spacer(
          flex: 5,
        ),
        Expanded(
          flex: 3,
          child: Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    title3,
                    style: TextStyle(
                        fontFamily: "bold", color: white, fontSize: 36),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  subtitle3,
                  style: TextStyle(
                      fontFamily: "normal", color: white, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
