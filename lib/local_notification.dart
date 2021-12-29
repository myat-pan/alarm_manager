// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

//  initNotifications() async {
//  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//     var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iOS = new IOSInitializationSettings();
//     var initSetttings = new InitializationSettings(android: android, iOS: iOS);
//     flutterLocalNotificationsPlugin.initialize(initSetttings,
//         onSelectNotification: selectNotification);
// }

// void selectNotification(String payload)  {
//   if (payload != null) {
//     debugPrint('notification payload: $payload');
//   }
//   //await FlutterRingtonePlayer.stop();
// }

// Future singleNotification(
//   DateTime now,
//    String title, String body, int hashCode,
//     { String sound}) async {
//   var androidChannel = const AndroidNotificationDetails(
//     'channel-id',
//     'channel-name',
//     //'channel-description',
//     importance: Importance.max,
//     priority: Priority.max,
//   );

//   var iosChannel = IOSNotificationDetails();
//   var platformChannel =
//       NotificationDetails(android: androidChannel, iOS: iosChannel);

//   // flutterLocalNotificationsPlugin.zonedSchedule(
//   //     hashCode, title, body, scheduledDate, platformChannel,
//   //     payload: hashCode.toString(), androidAllowWhileIdle: null, uiLocalNotificationDateInterpretation: null);
// }
