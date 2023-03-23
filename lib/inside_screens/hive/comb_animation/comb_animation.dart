import 'dart:async';
import 'package:beemodoro/const/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CombAnimation extends StatefulWidget {
  final String comb;
  final Color textColor;
  const CombAnimation({super.key, required this.comb, required this.textColor});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<CombAnimation>
    with TickerProviderStateMixin {
  late AnimationController firstController;
  late Animation<double> firstAnimation;

  late AnimationController secondController;
  late Animation<double> secondAnimation;

  late AnimationController thirdController;
  late Animation<double> thirdAnimation;

  late AnimationController fourthController;
  late Animation<double> fourthAnimation;
  Timer? _timer1;
  Timer? _timer2;
  Timer? _timer3;
  @override
  void initState() {
    super.initState();

    firstController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    firstAnimation = Tween<double>(begin: 1.9, end: 2.1).animate(
        CurvedAnimation(parent: firstController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          firstController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          firstController.forward();
        }
      });

    secondController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    secondAnimation = Tween<double>(begin: 1.8, end: 2.4).animate(
        CurvedAnimation(parent: secondController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          secondController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          secondController.forward();
        }
      });

    thirdController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    thirdAnimation = Tween<double>(begin: 1.8, end: 2.4).animate(
        CurvedAnimation(parent: thirdController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          thirdController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          thirdController.forward();
        }
      });

    fourthController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    fourthAnimation = Tween<double>(begin: 1.9, end: 2.1).animate(
        CurvedAnimation(parent: fourthController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          fourthController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          fourthController.forward();
        }
      });

    //
    _timer1 = Timer(Duration(seconds: 2), () {
      firstController.forward();
    });

    _timer2 = Timer(Duration(milliseconds: 1600), () {
      secondController.forward();
    });
    _timer3 = Timer(Duration(milliseconds: 800), () {
      thirdController.forward();
    });
    _timer1;
    _timer2;
    _timer3;

    fourthController.forward();
  }

  @override
  void dispose() {
    firstController.dispose();
    _timer1!.cancel();
    secondController.dispose();
    _timer2!.cancel();
    thirdController.dispose();
    _timer3!.cancel();
    fourthController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ClipPath(
      clipper: MyPolygon(),
      child: Scaffold(
        backgroundColor: Color(0xffFFD34E).withAlpha(150),
        body: Stack(
          children: [
            Center(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(widget.comb,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        wordSpacing: 3,
                        color: widget.textColor.withOpacity(.7)),
                    textScaleFactor: 3),
              ),
            ),
            CustomPaint(
              painter: MyPainter(
                firstAnimation.value,
                secondAnimation.value,
                thirdAnimation.value,
                fourthAnimation.value,
              ),
              child: SizedBox(
                height: size.height,
                width: size.width,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyPolygon extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addPolygon([
      Offset(0, size.height / 2),
      Offset(size.width * 1 / 4, size.height),
      Offset(size.width * 3 / 4, size.height),
      Offset(size.width, size.height / 2),
      Offset(size.width * 3 / 4, 0),
      Offset(size.width * 1 / 4, 0)
    ], true);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class MyPainter extends CustomPainter {
  final double firstValue;
  final double secondValue;
  final double thirdValue;
  final double fourthValue;

  MyPainter(
    this.firstValue,
    this.secondValue,
    this.thirdValue,
    this.fourthValue,
  );

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color(0xffFFD34E).withOpacity(.8)
      ..style = PaintingStyle.fill;

    var path = Path()
      ..moveTo(0, size.height / firstValue)
      ..cubicTo(size.width * .4, size.height / secondValue, size.width * .7,
          size.height / thirdValue, size.width, size.height / fourthValue)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
