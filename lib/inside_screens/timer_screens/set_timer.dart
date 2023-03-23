import 'package:beemodoro/const/consts.dart';
import 'package:beemodoro/inside_screens/timer_screens/timer_screen.dart';
import 'package:beemodoro/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class SetTimer extends StatefulWidget {
  const SetTimer({super.key});

  @override
  State<SetTimer> createState() => _SetTimerState();
}

int? _selectedIndex;
List<int> timeList = [25, 50];
List<Widget> timerWidgetList = [];

class _SetTimerState extends State<SetTimer> {
  @override
  Widget build(BuildContext context) {
    timerWidgetList.clear();
    for (int i = 0; i < timeList.length; i++) {
      timerWidgetList.add(timerWidget(i));
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Spacer(
              flex: 2,
            ),
            Wrap(
              children: timerWidgetList,
            ),
            Spacer(
              flex: 2,
            ),
            ElevatedButton(
                onPressed: _selectedIndex != null
                    ? () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TimerScreen(
                                    time: timeList[_selectedIndex!] * 60)));
                      }
                    : null,
                child: Text("Başlat")),
            Spacer(),
          ],
        ),
      ),
    );
  }

  timerWidget(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: _selectedIndex == index ? mainColor : grey,
              borderRadius: BorderRadius.circular(24)),
          height: 150,
          width: 150,
          child: Center(
              child: Text(
            timeList[index].toString(),
            style: TextStyle(
              fontFamily: "bold",
              fontSize: 22,
              color: _selectedIndex == index ? grey : mainColor,
            ),
          ))),
    );
  }
}
