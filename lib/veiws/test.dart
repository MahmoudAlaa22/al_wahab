// import'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:intl/intl.dart';
//
// import '../main.dart';
// class Test extends StatefulWidget {
//   @override
//   _TestState createState() => _TestState();
// }
//
// class _TestState extends State {
//   FlutterLocalNotificationsPlugin fltrNotification;
//   String _selectedParam;
//   String task;
//   int val;
//
//   @override
//   void initState() {
//     super.initState();
//     _alarmTime = DateTime.now();
//     var androidInitilize = new AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iOSinitilize = new IOSInitializationSettings();
//     var initilizationsSettings =
//     new InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
//     fltrNotification = new FlutterLocalNotificationsPlugin();
//     fltrNotification.initialize(initilizationsSettings,
//         onSelectNotification: notificationSelected);
//   }
//
//   Future scheduleAlarm(
//       DateTime scheduledNotificationDateTime) async {
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'alarm_notif',
//       'alarm_notif',
//       'Channel for Alarm notification',
//       // icon: '@mipmap/ic_launcher',
//       sound: RawResourceAndroidNotificationSound('azan'),
//       // largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
//     );
//
//     var iOSPlatformChannelSpecifics = IOSNotificationDetails(
//         sound: 'azan.mp3v',
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true);
//     var platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
//
//     await fltrNotification.schedule(0, 'Office', "asdas",
//         scheduledNotificationDateTime, platformChannelSpecifics);
//   }
//
//   DateTime _alarmTime;
// String _alarmTimeString="DateTime.now().toString()";
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             RaisedButton(
//               onPressed: (){
//                 scheduleAlarm(_alarmTime);
//               },
//               child: new Text('Set Task With Notification'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 var selectedTime =
//                 await showTimePicker(
//                   context: context,
//                   initialTime:
//                   TimeOfDay.now(),
//                 );
//                 if (selectedTime != null) {
//                   final now = DateTime.now();
//                   var selectedDateTime =
//                   DateTime(
//                       now.year,
//                       now.month,
//                       now.day,
//                       selectedTime.hour,
//                       selectedTime
//                           .minute);
//                   setState(() {
//                     _alarmTime =
//                         selectedDateTime;
//                     _alarmTimeString =
//                         DateFormat('HH:mm')
//                             .format(
//                             selectedDateTime);
//                   });
//                 }
//               },
//               child: Text(
//                 _alarmTimeString,
//                 style:
//                 TextStyle(fontSize: 32,color: Colors.amber),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future notificationSelected(String payload) async {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         content: Text("Notification Clicked $payload"),
//       ),
//     );
//   }
// }