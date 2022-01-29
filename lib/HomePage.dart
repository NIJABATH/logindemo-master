import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:logindemo/profile.dart';
import 'package:logindemo/service.dart';
import 'package:logindemo/service.dart';
import 'package:logindemo/service.dart';
import 'package:logindemo/support.dart';
import 'ChatScreen.dart';
import 'api.dart';
import 'components/ChatHome.dart';
import 'db.dart';
import 'globals.dart' as globals;
import 'attendance.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // @override
  // void initState()  {
  //   // _totalNotifications = 0;
  //   // registerNotification();
  //   // checkForInitialMessage();
  //
  //   onNewToken();
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //
  //     if (message != null) {
  //       Get.to(ChatScreen());
  //     }
  //
  //     PushNotification notification = PushNotification(
  //       title: message.notification?.title,
  //       body: message.notification?.body,
  //       dataTitle: message.data['title'],
  //       dataBody: message.data['body'],
  //     );
  //
  //     // setState(() {
  //     //   _notificationInfo = notification;
  //     //   _totalNotifications++;
  //     // });
  //   });
  //
  //   super.initState();
  //
  // }

  void logout() async {
    globals.userID = '';
    globals.password = '';
    await deleteSettings();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                logout();
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => LoginScreen()));
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false);
                // do something
              },
            )
          ],
        ),
        body: Container(
            child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            GestureDetector(
              // onTap: () {
              //Navigator.push(context,
              //   MaterialPageRoute(builder: (_) => Photo()));
              //print("Container was tapped");
              // },
              child: Container(
                child: Center(
                  child: GestureDetector(
                    // onTap: () {
                    //   //PhotoState.showSelectionDialog();
                    //   Navigator.push(context,
                    //       MaterialPageRoute(builder: (context) => Photo()));
                    // },
                    child: Container(
                      width: 200,
                      height: 150,
                      /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                      child: Image.asset('asset/images/user.png'),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 40,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
              color: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              //child: new BackdropFilter(
              //filter: new ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
              //child: new Container(
              // decoration: new BoxDecoration(
              //  color: Colors.grey.shade200.withOpacity(0.6)
              // ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.account_box_rounded,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            // ),
            // ),
            Container(
              height: 10,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Attendance()));
              },
              color: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Attendance',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.addchart_sharp,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 10,
            ),
            RaisedButton(
              onPressed: () {},
              color: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Application',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.now_widgets,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 10,
            ),
            RaisedButton(
              onPressed: () async {
                getSettings();
                 var t = await getMessageDetails('2');
                 // if(t == null){
                 //   return CircularIndicator();
                 // }else {
                if(t != null){
                   Get.to(
                     // ChatScreen(
                     // name: globals.userName,
                     // screenId: '2',
                     // screen: "Suggestions")
                       ChatHome(screenId: '2',
                           screen: "Suggestions")
                   );
                 }
              },
              color: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Suggestions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.new_releases_rounded,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 10,
            ),
            RaisedButton(
              onPressed: () {
                Get.to(ChatScreen(
                    name: globals.userName,
                    screenId: '1',
                    screen: "Announcement"));
              },
              color: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Announcement',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.record_voice_over_rounded,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 10,
            ),
            RaisedButton(
              onPressed: () {
                Get.to(Support());
              },
              color: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Support',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.phone_enabled_rounded,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ],
        )));
  }

// void onNewToken() async {
//   String? token = await FirebaseMessaging.instance.getToken();
//
//   Map<String, dynamic> json = {
//     "Id": globals.userID.toString(),
//     "token": token,
//   };
//   //_values.add(json);
//   token = jsonEncode(json);
//   logFirebaseToken(token);
// }
}
