// import 'dart:math';

// import 'package:android_alarm_manager/android_alarm_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   String countKey = "count";
//   late SharedPreferences prefs;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   Future<bool> initSettings() async {
//     bool init = await AndroidAlarmManager.initialize();
//     prefs = await SharedPreferences.getInstance();
//     if (!prefs.containsKey(countKey)) {
//       prefs.setInt(countKey, 0);
//     }
//     return init;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//           child: ElevatedButton(
//               onPressed: () async {
//                 await AndroidAlarmManager.oneShot(
//                     const Duration(seconds: 1), Random().nextInt(3),
//                     (int id) async {
//                   int? currentCount = prefs.getInt(countKey);
//                   await prefs.setInt(countKey, currentCount! + 1);
//                 }, exact: true, alarmClock: true, wakeup: true);
//               },
//               child: Text("Schedule OneShot Alarm"))),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }


