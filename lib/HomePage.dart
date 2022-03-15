import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:pasons_HR/profile.dart';
import 'package:pasons_HR/service.dart';
import 'ChatScreen.dart';
import 'api.dart';
import 'components/AnnouncementHome.dart';
import 'components/ChatHome.dart';
import 'components/UserChatHome.dart';
import 'db.dart';
import 'globals.dart' as globals;
import 'attendance.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _splashFlag = false;
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

  void  initState()  {
    super.initState();
     Firebase.initializeApp();

    // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    //
    // _firebaseMessaging
    //     .getToken()
    //     .then((String? token) {
    //   assert(token != null);
    // });

    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   if (message != null) {
    //     Get.to(ChatScreen(name: globals.userName,
    //       screenId: message.data['screenId'],
    //       screen: message.data['screenName'],
    //       messageId:"",
    //       groupId: message.data['groupId'],
    //       receiverId: message.data['receiverId'],));      }
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    //   // if (message.data['screenId'] == "2") {
    //   Get.to(ChatScreen(name: globals.userName,
    //     screenId: message.data['screenId'],
    //     screen: message.data['screenName'],
    //     messageId:"",
    //     groupId: message.data['groupId'],
    //     receiverId: message.data['receiverId'],));
    // });
  }

  void async;  logout() async {
    await Logout();
    globals.userID = '';
    globals.password = '';
    await deleteSettings();
    setState(() {
      _splashFlag = false;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    if(!_splashFlag) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () async {
                await logout();
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => LoginScreen()));
                // if(!_splashFlag) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false);
                // }else {
                // // Get.to(ErrorPage())
                // return CircularIndicator();
                // }
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
                      // child: Image.asset('asset/images/user.png'),
                       child: CircleAvatar(
                          radius: 24,
                          backgroundImage:  globals.userImagePath != ''
                              ? NetworkImage(globals.userImagePath)
                              : AssetImage('asset/images/user.png') as ImageProvider,
                        )
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
                 var t = await getMessageGroupDetails('2');
                 // if(t == null){
                 //   return CircularIndicator();
                 // }else {
                if(t != null){
                   Get.to(
                     // ChatScreen(
                     // name: globals.userName,
                     // screenId: '2',
                     // screen: "Suggestions")
                       globals.privilegeId == 2 ? ChatHome(screenId: '2',
                           screen: "Suggestions") :
                       UserChatHome(screenId: '2',
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
                Get.to(
                    // ChatScreen(
                    // name: globals.userName,
                    // screenId: '1',
                    // screen: "Announcement")
                    AnnouncementHome(screenId: '1',
                        screen: "Announcement")
                );
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
                // Get.to(Support());
                ChatHome(screenId: '3',
                    screen: "su[[ort");
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
        )));}else {
  // Get.to(ErrorPage())
  return CircularIndicator();
  }
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
