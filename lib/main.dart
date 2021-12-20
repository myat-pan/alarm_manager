// import 'package:alarm_manager/home_page.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Ringtone player'),
//         ),
//         body: Center(
//           child: Column(
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.all(8),
//                 child: ElevatedButton(
//                   child: const Text('Play Sound'),
//                   onPressed: () {
//                     FlutterRingtonePlayer.play(
//                       android: AndroidSounds.ringtone,
//                       ios: IosSounds.receivedMessage,
//                       looping: true,
//                       volume: 1.0,
//                       asAlarm: true,
//                     );
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(8),
//                 child: ElevatedButton(
//                   child: const Text('Stop Sound'),
//                   onPressed: () {
//                     FlutterRingtonePlayer.stop();
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:alarm_manager/local_notification.dart' as notify;
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';

// /// A port used to communicate from a background isolate to the UI isolate.
final ReceivePort port = ReceivePort();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register the UI isolate's SendPort to allow for communication from the
  // background isolate.
  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName,
  );

  notify.initNotifications();

  AndroidAlarmManager.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // // The background
  static SendPort? uiSendPort;

  Future<void> showNotification(data) async {
    print(data);
    var rand = Random();
    var hash = rand.nextInt(100);
    DateTime now = DateTime.now().toUtc().add(Duration(seconds: 1));

    await notify.singleNotification(
      now,
      "Hello $hash",
      "This is hello message",
      hash,
      sound: '',
    );
    FlutterRingtonePlayer.play(
        android: AndroidSounds.ringtone,
        ios: IosSounds.glass,
        volume: 1.0,
        looping: true,
        asAlarm: true);
  }

  // The callback for our alarm
  static Future<void> callback() async {
    print('Alarm fired!');
    // // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName)!;
    uiSendPort?.send("hi");
  }

  @override
  void initState() {
    super.initState();

    port.listen((data) async => await showNotification(data));

    runAlarm();
  }

  void runAlarm() async {
    await AndroidAlarmManager.periodic(
      Duration(seconds: 1),
      0,
      callback,
      rescheduleOnReboot: true,
      exact: true,
      wakeup: true,
    );

    print("OK");
  }

  void callAlarm() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Notification here"),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SendPort>('uiSendPort', uiSendPort));
  }
}
