
import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'Models/Message.dart';
import 'components/MessageBubble.dart';
import 'Models/MessageCard.dart';
import 'SignalRHelper.dart';
import 'package:localstore/localstore.dart';
import 'api.dart';
import 'components/AnnouncementHome.dart';
import 'db.dart';
import 'globals.dart' as globals;

class ChatScreen extends StatefulWidget {
  final name;
  final screenId;
  final screen;
  final messageId;
  final groupId;
  final receiverId;
  final senderID;
  final Stream<int> stream;

  // method() => createState().deleteMessageFromList('1');
  final _ChatScreenState chatScreenState = new _ChatScreenState();

   ChatScreen(
      {Key? key, this.name, this.screenId, this.screen, this.messageId, this.groupId,this.receiverId,this.senderID,required this.stream})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();

  void deleteMessageFromList(id) {
    chatScreenState.deleteMessageFromList(id);
  }
}

class _ChatScreenState extends State<ChatScreen> {
  var scrollController = ScrollController();
  var txtController = TextEditingController();
  final db = Localstore.instance;

  // void printSample() {
  //   print("Sample text");
  // }

  // late bool flg = false;
  SignalRHelper signalR = new SignalRHelper();

  // Future<Database> initializeDB() async {
  //   String path = await getDatabasesPath();
  //   return openDatabase(
  //     join(path, 'pasonsHr.db'),
  //     onCreate: (database, version) async {
  //       await database.execute(
  //         "CREATE TABLE textMessage(id INTEGER PRIMARY KEY AUTOINCREMENT,messageId TEXT NOT NULL, name TEXT NOT NULL,message TEXT NOT NULL,screenId int NOT NULL,groupName TEXT NOT NULL)",
  //       );
  //     },
  //     version: 1,
  //   );
  // }

  void deleteMessageFromList(String messageId) {
    // setState(() {
      signalR.messageList.removeWhere((item) => item.messageId == messageId);
    // });
      deleteMessage(messageId);
  }

  void sendDeleteMessage(String messageId) {
    deleteMessageFromList(messageId);
    signalR.sendMessage(
        widget.name, txtController.text, globals.myGroupName, messageId,widget.groupId,widget.receiverId, false);
    sendPushNotification(messageId,widget.groupId,txtController.text,
        widget.screenId, false,widget.receiverId);
  }



  // Future<int> insertAnnouncement(String name, String message) async {
  //   int result = 0;
  //   final Database db = await initializeDB();
  //   // result = await db.insert('announcement', message.toMap());
  //   result = await db.rawInsert(
  //       'INSERT INTO textMessage(name,messageId, message,screenId,groupName) VALUES("' +
  //           name +
  //           '","' +
  //           message +
  //           '","' +
  //           widget.screenId +
  //           '","' +
  //           globals.myGroupName +
  //           '")');
  //   return result;
  // }

  Future<List<Message>> retrieveMessage() async {
    List<Map> list;
    if(widget.groupId != "0"){
      final Database db = await initializeDB();
      list = await db.rawQuery(
          'SELECT * FROM textMessage where screenId =' + widget.screenId + ' AND groupId =' + widget.groupId);
      // final List<Map<String, Object?>> queryResult =
      await db.query('textMessage');
      setState(() {
        int i = 0;
        for (var message in list) {
          signalR.messageList.add(Message(
              messageId: message["messageId"],
              name: message["name"],
              groupName: message["groupName"],
              message: message["message"],
              messageStatus: message["messageStatus"],
              time:message["time"],
              isMine: message["name"] == widget.name));
          i++;
        }
        // scrollController.jumpTo(scrollController.position.maxScrollExtent + 200 * i);
        scrollController.animateTo(scrollController.position.maxScrollExtent + 200 * i ,
            duration: Duration(milliseconds: 1), curve: Curves.easeInOut);
      });
      // setState(() {
      //   flg = true;
      // });
      // });

    }else {

      final Database db = await initializeDB();
      list = await db.rawQuery(
          'SELECT * FROM textMessage where screenId =' + widget.screenId + ' AND groupId =' + widget.groupId + ' AND senderID =' + widget.receiverId);
      // final List<Map<String, Object?>> queryResult =
      await db.query('textMessage');
      setState(() {
        int i = 0;
        for (var message in list) {
          signalR.messageList.add(Message(
              messageId: message["messageId"],
              name: message["name"],
              groupName: message["groupName"],
              message: message["message"],
              messageStatus: message["messageStatus"],
              time:message["time"],
              isMine: message["name"] == widget.name));
          i++;
        }
        // scrollController.jumpTo(scrollController.position.maxScrollExtent + 200 * i);
        scrollController.animateTo(scrollController.position.maxScrollExtent + 200 * i ,
            duration: Duration(milliseconds: 1), curve: Curves.easeInOut);
      });
      // setState(() {
      //   flg = true;
      // });
      // });

    }
    return list.cast();

    // return true;
  }

  // else if( args[4] == widget.groupId ){
  // signalR.messageList.add(Message(
  // name: args[0],
  // message: args[1],
  // groupName: args[2],
  // messageId: args[3],
  // messageStatus: args[5],
  // time:args[7],
  // isMine: args[0] == widget.name));
  // scrollController.animateTo(
  // scrollController.position.maxScrollExtent + 75,
  // duration: Duration(seconds: 1),
  // curve: Curves.fastOutSlowIn,
  // );
  //
  // }

  receiveMessageHandler(args) {
    if(args[8] != globals.userID) {
      if (!args[5]) {
        deleteMessageFromList(args[3]);
      }
      // else if(args[8] != globals.userID && (args[6] == globals.userID || args[4] == widget.groupId)){
      else if ((args[8] == widget.receiverId && args[6] == widget.senderID) ||
          (args[4] != "0" && args[4] == widget.groupId)) {
        signalR.messageList.add(Message(
            name: args[0],
            message: args[1],
            groupName: args[2],
            messageId: args[3],
            messageStatus: args[5],
            time: args[7],
            isMine: args[0] == widget.name));
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 75,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      }
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  // deleteMessageFromList() {
  //   setState(() {});
  // }



  // @override
  // Widget build(BuildContext context) {
  //   return WillPopScope(
  //     onWillPop: () async {
  //       onBackPressed(); // Action to perform on back pressed
  //       return false;
  //     },
  //     child: Scaffold(),
  //   );
  // }

//   WillPopScope(
//   onWillPop: () async {
//   getMessageGroupDetails(widget.screenId);
//   // Navigator.pop(context);
//   // setState(() {
//   // });
//   return false;
// },
// child:

  Future<bool> _onBackPressed() async {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) =>  AnnouncementHome(screenId: '1',
    //       screen: "Announcement")),
    // );
       Navigator.pop(context);
      // Navigator.pushReplacementNamed(context, "AnnouncementHome");

         return false;
  }

    @override
  Widget build(BuildContext context) {
      globals.groupID = widget.groupId == "0" ? "1" : widget.groupId;
      globals.senderID = widget.receiverId;
      globals.screenID = widget.screenId;
      signalR.messageList = globals.messageList;
      // if( flg == true && signalR.messageList[0].message != null) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child:
        Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/images/doodle_backgound2.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(widget.screen),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: signalR.messageList.length,
                  itemBuilder: (context, i) {
                    return MessageBubble(
                      delete: sendDeleteMessage,
                      messageId: signalR.messageList[i].messageId,
                      sender: signalR.messageList[i].name,
                      groupName: signalR.messageList[i].groupName,
                      text: signalR.messageList[i].message,
                      time: signalR.messageList[i].time,
                      isMe: signalR.messageList[i].isMine,
                    );
                  },
                ),
              ),
              globals.messagePermission || widget.screenId == '2'
                  ? Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: txtController,
                          decoration: InputDecoration(
                            hintText: 'Send Message',
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.send,
                                color: Colors.lightBlue,
                              ),
                              onPressed: () {
                                //  insertAnnouncement(globals.userName,txtController.text, 1);
                                if (txtController.text != "") {
                                  globals.lastMessageId =
                                      globals.lastMessageId + 1;
                                  globals.messageId = globals.userID +
                                      '-' +
                                      globals.lastMessageId.toString();
                                  saveMessage(
                                      globals.messageId,
                                      globals.userName,
                                      txtController.text,
                                      widget.screenId,
                                      globals.myGroupName,
                                       widget.groupId,
                                      widget.receiverId,DateFormat('MM/dd/yy hh:mm tt').format(DateTime.now()));
                                  // signalR.sendMessage(
                                  //     widget.name,
                                  //     txtController.text,
                                  //     globals.myGroupName,
                                  //     globals.messageId,
                                  //     widget.groupId,
                                  //     widget.receiverId,
                                  //     true);
                                  signalR.messageList.add(Message(
                                      name: widget.name,
                                      message:txtController.text,
                                      groupName: globals.myGroupName,
                                      messageId: globals.messageId,
                                      messageStatus: true,
                                      time:DateFormat('MM/dd/yy hh:mm tt').format(DateTime.now()),
                                      isMine: true));
                                  scrollController.animateTo(
                                    scrollController.position.maxScrollExtent + 75,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.fastOutSlowIn,
                                  );
                                  if (this.mounted) {
                                    setState(() {});
                                  }
                                  sendPushNotification(globals.messageId,widget.groupId,txtController.text,
                                      widget.screenId, true,widget.receiverId,);
                                  txtController.clear();
                                  scrollController.jumpTo(scrollController
                                          .position.maxScrollExtent +
                                      220);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                  : Card(),
            ],
          ),
        )));
    // }else{
    //   return CircularIndicator();
    // }
  }

  @override
  void initState() {
    StreamController controller = StreamController();
    controller.addStream(widget.stream);
    super.initState();
    if(!controller.hasListener) {
      widget.stream.listen((list) {
        refresh();
      });
    }
    // signalR.connect(receiveMessageHandler);
    if (signalR.messageList.length == 0) {
      retrieveMessage();
    }
  }

  void refresh(){
    if (this.mounted) {
      setState(() {
      });
    }
  }

  @override
  void dispose() {
    txtController.dispose();
    scrollController.dispose();
    // signalR.disconnect();
    super.dispose();
  }

// getanouncementAll  (String s) async {
//    return  await getAll('1');
//  }

}
