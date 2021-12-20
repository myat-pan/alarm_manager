import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initNotifications() async {
  var initializeAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializeIOS = IOSInitializationSettings();
  var initializationSettings =
      InitializationSettings(android: initializeAndroid, iOS: initializeIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
}

void selectNotification(String? payload) async {
  if (payload != null) {
    debugPrint('notification payload: $payload');
  }
  await FlutterRingtonePlayer.stop();
}

Future singleNotification(
    DateTime scheduledDate, String title, String body, int hashCode,
    {required String sound}) async {
  var androidChannel = AndroidNotificationDetails(
    'channel-id',
    'channel-name',
    //'channel-description',
    importance: Importance.max,
    priority: Priority.max,
  );

  var iosChannel = IOSNotificationDetails();
  var platformChannel =
      NotificationDetails(android: androidChannel, iOS: iosChannel);

  flutterLocalNotificationsPlugin.schedule(
      hashCode, title, body, scheduledDate, platformChannel,
      payload: hashCode.toString());
}
