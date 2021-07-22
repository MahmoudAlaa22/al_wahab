import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/controller/provider.dart';
import 'package:al_wahab/controller/theme_provider.dart';
import 'package:al_wahab/model/pray.dart';
import 'package:al_wahab/widgets/style_widget.dart';
import 'package:al_wahab/widgets/widgets.dart';

import '../main.dart';

class PrayerTimeList extends StatefulWidget {
  List<String> prayerTimes = [];
  List<String> prayerNames = [];
  List<Map> prayTimes = [];
  DateTime timeOfCurrentlyPray;

  PrayerTimeList(
      {this.prayerNames,
      this.prayerTimes,
      this.prayTimes,
      this.timeOfCurrentlyPray});

  @override
  _PrayerTimeListState createState() => _PrayerTimeListState();
}

class _PrayerTimeListState extends State<PrayerTimeList> {
  ChangeTime changeTime;
  final now = new DateTime.now();

  ThemeProvider themeProvider;

  @override
  void initState() {
    // scheduleAlarm(scheduledNotificationDateTime: widget.timeOfCurrentlyPray)
    //     .then((value) => log("Timeeeeeee"));

    super.initState();
  }

  Future scheduleAlarm({DateTime scheduledNotificationDateTime}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      // icon: '@mipmap/ic_launcher',
      sound: RawResourceAndroidNotificationSound('azan'),
      // largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'azan.mp3v',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await fltrNotification.schedule(
        0,
        'حان الان موعد اذان',
        "صلاة ${widget.prayTimes[0][Pray.nameInAr]}",
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    changeTime = Provider.of(context);
    themeProvider = Provider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    log(
        widget.timeOfCurrentlyPray == null ? "xcvxvcxv" : "timeOfCurrentlyPray is ${widget.timeOfCurrentlyPray}");

    return (Constants.long != null && Constants.lat != null)
        ? widget.prayerTimes.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : prayerListWidget()
        : const Center(
            child: Text("الرجاء السماح للتطبيق الوصول الي موقعك الحالي"),
          );
  }

  Widget prayerListWidget() {
    return Stack(
      children: [
        Column(
          children: [
            widgetText(
                text: widget.prayTimes.isNotEmpty
                    ? "${widget.prayTimes[0][Pray.nameInAr]} بعد"
                    : "",
                fontSize: 25,
                color: Color(Constants.mainColor)),
            Center(
                child: Text(
              changeTime.timeString,
              style: TextStyle(
                fontSize: getScreenOfWidth * 0.2as double,
                fontWeight: FontWeight.bold,
              ),
            )),
            Container(
              height: getScreenOfHeight * 0.2as double,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.prayerTimes.length,
                itemBuilder: (context, i) {
                  // howToCalculateChangeInPray(i);
                  if (i != 4) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: contTimeOfPray(widget.prayerNames[i],
                          widget.prayerTimes[i], Constants.nameOfPrayLise[i]as String),
                    );
                  }
                  return Row();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget contTimeOfPray(String nameInEng, String time, String nameInAr) {
    // log("formattedDate is ${formattedDate}");

    var nameOfPray = '';
    if (widget.prayTimes.isNotEmpty) {
      nameOfPray = widget.prayTimes[0][Pray.nameInEn]as String;
      log("nameOfPray is $nameOfPray");
    }

    return Container(
      padding: const EdgeInsets.all(5),
      width: getScreenOfWidth * 0.2as double,
      decoration: BoxDecoration(
        color: (nameOfPray == nameInEng)
            ? Colors.white
            : Color(Constants.mainColor),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [styleOfBoxShadow(blurRadius: 5)],
        border: Border.all(color: Color(Constants.mainColor)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          widgetText(
              text: nameInAr,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: (nameOfPray == nameInEng)
                  ? Color(Constants.mainColor)
                  : Colors.white),
          Container(
              width: getScreenOfWidth * 0.15as double,
              height: getScreenOfWidth * 0.15as double,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (nameOfPray == nameInEng)
                    ? Color(Constants.mainColor)
                    : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Image.asset("assets/images/$nameInEng.png")),
          widgetText(
            text: time,
            fontSize: 15,
          ),
        ],
      ),
    );
  }
}
