
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:overlay_support/overlay_support.dart';
import 'db.dart';
import 'globals.dart' as globals;
import 'HomePage.dart';
import 'api.dart';
import 'login.dart';
import 'ChatScreen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  if(message.data['status'] == 'True') {
    if (message.notification?.title != null) {
      // saveMessage('1','1',message.notification?.body,'nhk');
      saveMessage(message.data['messageId'], message.data['senderName'],
          message.notification?.body, message.data['screenId'],
          message.data['groupName']);
      // AndroidNotification? android = message.notification?.android;
      // flutterLocalNotificationsPlugin.show(
      //     message.data.hashCode,
      //     message.data['title'],
      //     message.data['body'],
      //     NotificationDetails(
      //       android: AndroidNotificationDetails(
      //         channel.id,
      //         channel.name,
      //         channelDescription: channel.description,
      //         icon: android?.smallIcon,
      //       ),
      //     ));
    }
  }else{
    // method() => createState().deleteMessageFromList('1');
    ChatScreen chat = new ChatScreen();
    chat.deleteMessageFromList(message.data['messageId']);
  }
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  // 'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.data['status'] == "False") {
      ChatScreen chat = new ChatScreen();
      chat.deleteMessageFromList(message.data['messageId']);
    }
  });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    if (message.data['click_action'] == "announcement") {
      Get.to(ChatScreen(name:globals.userName));
    }
  });
  runApp(MyApp());
  globals.isLoggedIn = false;
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
        child: GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      //home: LoginDemo(),
    ));
  }
}

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> with InputValidationMixin {
  final formGlobalKey = GlobalKey<FormState>();
  bool autovalidateMode = true;

  // bool _showLoading = false;
  late final FirebaseMessaging _messaging;
  late int _totalNotifications;
  PushNotification? _notificationInfo;

  @override
  void initState() {
    _totalNotifications = 0;
    // registerNotification();
    // checkForInitialMessage();

    onNewToken();

    super.initState();

  }

  checkForInitialMessage() async {
    // await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    }
  }

  @override
  late Future<String> _futureJwt;
  final TextEditingController _userid = TextEditingController();

  //Getting the password from the textField
  final TextEditingController _password = TextEditingController();

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('asset/images/bk2.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: new ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: [
              // _showLoading
              //     ?Container(
              //     padding: const EdgeInsets.symmetric(horizontal: 0.0,vertical: 0.0),
              //     color: Colors.black.withOpacity(0.5),child: Center(
              //     child: CircularProgressIndicator())): new Container(),
              Column(
                children: <Widget>[
                  Center(
                    child: Container(
                        width: 200,
                        height: 150,
                        /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                        child: Image.asset('asset/images/pasons.png')),
                  ),
                  Padding(
                    //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                    child: Form(
                      key: formGlobalKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'User ID',
                                hintText: 'Enter valid User ID'),
                            controller: _userid,
                            validator: (_userid) {
                              if (_userid == null || _userid.isEmpty) {
                                return 'user ID is required';
                              }
                              if (isUserIDValid(_userid))
                                return null;
                              else
                                return 'Enter valid User ID';
                            },
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                hintText: 'Enter secure password'),
                            controller: _password,
                            validator: (_password) {
                              if (_password == null || _password.isEmpty) {
                                return 'password is required';
                              }
                              if (isPasswordValid(_password))
                                return null;
                              else
                                return 'Enter valid Password';
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  //FlatButton(
                  //  onPressed: () {
                  //TODO FORGOT PASSWORD SCREEN GOES HERE
                  // },
                  //child: Text(
                  // 'Forgot Password',
                  //  style: TextStyle(color: Colors.blue, fontSize: 15),
                  //),
                  //  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                  ),
                  Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: FlatButton(
                      onPressed: () async {
                        //_showLoading = true;
                        if (_userid.text != "" && _password.text != "") {
                          buildShowDialog(context);
                          var connectivityResult = await (_futureJwt =
                              createLoginState(_userid.text, _password.text));
                          if (connectivityResult == '1') {
                            //_showLoading = false;
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          } else if (connectivityResult == '2') {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('password or userid is wrong'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else if (connectivityResult == '3') {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('no response from server'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }

                        if (formGlobalKey.currentState!.validate()) {
                          CircularProgressIndicator();
                          new Row(children: <Widget>[
                            new CircularProgressIndicator(),
                          ]);
                          // formGlobalKey.currentState.save();
                          // use the email provided here
                        }
                      },
                      // navigate to the desired route
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => HomePage()));,

                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 130,
                  ),
                  // new GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => SignupPage()));
                  //    // Navigator.pushNamed(context, "signup");
                  //   },
                  //   child: new Text("New User? Create Account"),
                  // ),
                  //Text('New User? Create Account')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void registerNotification() async {
    // await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
            'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });

        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          );

          showOverlayNotification((context) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: SafeArea(
                child: ListTile(
                  leading: SizedBox.fromSize(
                      size: const Size(40, 40),
                      child: ClipOval(
                          child: Container(
                        color: Colors.black,
                      ))),
                  title: Text(message.data['title']),
                  subtitle: Text(message.data['body']),
                  trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        OverlaySupportEntry.of(context)?.dismiss();
                      }),
                ),
              ),
            );
          }, duration: Duration(milliseconds: 4000));
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }
}

mixin InputValidationMixin {
  bool isPasswordValid(String password) {
    String pattern = r'[0-9]$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(password);
  }

  bool isUserIDValid(String userID) {
    String pattern = r'[0-9]$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(userID);
  }
}
