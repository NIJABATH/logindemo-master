import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import '../api.dart';

class Server {
  StreamController<String> _controller = new StreamController.broadcast();
  void simulateMessage(String message) {
    _controller.add(message);
  }

  Stream get messages => _controller.stream;
}

final server = new Server();

class StreamScreen extends StatefulWidget {
  @override
  _StreamScreenState createState() => new _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen> {
  List<String> _messages = <String>[];
  late StreamSubscription<dynamic> _subscription;
  late StreamController _postsController;

  get http => null;
  @override
  void initState() {
    _subscription = server.messages.listen((message) async => setState(() {
      _messages.add(message);
    }));
    loadPosts();
    super.initState();
  }

  Future fetchPost([howMany = 5]) async {
    final response = await http.get(Uri.parse(
        'http://10.1.1.220:5001/api/Hrs/getAnnouncement?groupId=' + '1'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
    return getAnnouncement('1');
  }

  loadPosts() async {
    fetchPost().then((res) async {
      _postsController.add(res);
      return res;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.bodyText2 ;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Sample App'),
      ),
      body: new ListView(
        children: _messages.map((String message) {
          return new Card(
            child: new Container(
              height: 100.0,
              child: new Center(
                child: new Text(message, style: textStyle),
              ),
            ),
          );
        }).toList(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          new FloatingActionButton(
            child: new Icon(Icons.account_circle_outlined),
            onPressed: () {
              // simulate a message arriving
              server.simulateMessage('Hello World');
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          new FloatingActionButton(
            child: new Icon(Icons.account_circle_rounded),
            onPressed: () {
              // simulate a message arriving
              server.simulateMessage('Hi Flutter');
            },
          ),
        ],
      ),
    );
  }
}
//
// class SampleApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       home: new StreamScreen(),
//     );
//   }
// }
//
// void main() {
//   runApp(new SampleApp());
// }