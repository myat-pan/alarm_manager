import 'package:alarm_manager/app_manager.dart';
import 'package:alarm_manager/pusher/pusher_service.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  PusherService pusherService = PusherService();
  final TextEditingController _controller = TextEditingController();
  var channel = IOWebSocketChannel.connect(Uri.parse('wss://ws.ifelse.io/'));

  @override
  void initState() {
    // pusherService = PusherService();
    // pusherService.firePusher('public', 'create');
    super.initState();
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
    }
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
                }
                return Container(
                  height: 200,
                  child: Text(snapshot.data),
                );
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
