import 'dart:math';

import 'package:alarm_manager/app_manager.dart';
import 'package:alarm_manager/pusher/pusher_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() {
   WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pusher Web Socket',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  PusherService pusherService = PusherService();
  final TextEditingController _controller = TextEditingController();
   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var channel = IOWebSocketChannel.connect(Uri.parse('ws://192.168.2.123:5556'));
 // var channel =IOWebSocketChannel.connect(Uri.parse("wss://ws-ap1.pusher.com:443/app/6f1153d1c6b4c827e1c1"));

  @override
  void initState() {

    // pusherService = PusherService();
    // pusherService.firePusher('public', 'create');
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
    super.initState();
  }


  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Notification'),
        content: Text(payload),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    // pusherService.unbindEvents('create');
    super.dispose();
  }

  

  void sendData() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(_controller.text);
     // showNotification();
    }
  }

//    Future<void> showNotification() async {
//     var rand = Random();
//     var hash = rand.nextInt(100);
//     DateTime now = DateTime.now().toUtc().add(Duration(seconds: 1));
//  print("Heyyyyyyyyyyyyyyy");
//     await notify.singleNotification(
//       now,
//       "Hello $hash",
//       "This is hello message",
//       hash,
//       sound: '',
//     );
//   }

Future showNotification() async {
var android = AndroidNotificationDetails(
        'channel id', 'channel NAME',
        priority: Priority.high,importance: Importance.max
    );
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'WebSocket', 'Flutter Local Notification', platform,
        payload: 'Testing Websocket flutter.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pusher with web socket'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ElevatedButton(
            //     onPressed: showNotification,
            //     child: Text('Show Notification With Default Sound'),
            //   ),
            Container(
              // height: 400,
              child: Form(
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Send any message to the server"),
                  controller: _controller,
                ),
              ),
            ),
            StreamBuilder(
              stream: channel.stream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData) {
            
                  return Text("Null");
                  // return Shimmer.fromColors(
                  //   baseColor: Colors.grey[300]!,
                  //   highlightColor: Colors.grey[100]!,
                  //   child: ListView.builder(
                  //     itemCount: 4,
                  //     itemBuilder: (context, _) {
                  //       return Column(
                  //         children: [
                  //           SizedBox(height: 8),
                  //           Container(
                  //             margin: EdgeInsets.all(8),
                  //             padding: EdgeInsets.all(8),
                  //             //  width: 240,
                  //             height: 100,
                  //             color: Colors.grey[200],
                  //           ),
                  //           SizedBox(height: 8),
                  //           Text("Testing Web Socket",
                  //               style: TextStyle(
                  //                   backgroundColor: Colors.black,
                  //                   fontSize: 30)),
                  //           SizedBox(height: 8),
                  //         ],
                  //       );
                  //     },
                  //   ),
                  // );
                }else{
               var p = snapshot.data;
               showNotification();
                return Container(
                  height: 200,
                  child: Text(p),
                );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: sendData,
      ),
    );

}
}