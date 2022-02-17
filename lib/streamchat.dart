import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:pasons_HR/service.dart';

import 'api.dart';

// void main() => runApp(new MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Basic Project',
//       home: new MyHomePage(),
//     );
//   }
// }

class StreamChatScreen extends StatefulWidget {
  @override
  _StreamChatPageState createState() => new _StreamChatPageState();
}

class _StreamChatPageState extends State<StreamChatScreen> {
  late StreamController _postsController;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  int count = 1;

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

  showSnack() {
    return scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('New content loaded'),
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    count++;
    print(count);
    fetchPost(count * 6).then((res) async {
      _postsController.add(res);
      showSnack();
      return null;
    });
  }

  @override
  void initState() {
    _postsController = new StreamController();
    loadPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('StreamBuilder'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh',
            icon: Icon(Icons.refresh),
            onPressed: _handleRefresh,
          )
        ],
      ),
      body: StreamBuilder(
        stream: _postsController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || snapshot.data == null){
            return CircularIndicator();
          }
          if (!snapshot.data.exists) {
            return Text("Document does not exist");
          }
          print('Has error: ${snapshot.hasError}');
          print('Has data: ${snapshot.hasData}');
          print('Snapshot Data ${snapshot.data}');

          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: Scrollbar(
                    child: RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          var post = snapshot.data[index];
                          return ListTile(
                            title: Text(post['title']['rendered']),
                            subtitle: Text(post['date']),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          }else{
            return CircularIndicator();
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return Text('No Posts');
          }
          if (!snapshot.data.exists) {
            return Text("Document does not exist");
          }
        } ,
      ),
    );
  }
}
