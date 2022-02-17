
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'Models/Message.dart';
import 'Models/MessageCard.dart';
import 'SignalRHelper.dart';
import 'package:localstore/localstore.dart';
import 'api.dart';
import 'db.dart';
import 'globals.dart' as globals;

class ChatScreen extends StatefulWidget {
  final name;
  final screenId;
  final screen;
  final messageId;
  final groupId;

  // method() => createState().deleteMessageFromList('1');
  final _ChatScreenState chatScreenState = new _ChatScreenState();

   ChatScreen(
      {Key? key, this.name, this.screenId, this.screen, this.messageId, this.groupId})
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

  void printSample() {
    print("Sample text");
  }

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
        widget.name, txtController.text, globals.myGroupName, messageId,widget.groupId, false);
    sendPushNotification(messageId,widget.groupId,txtController.text,
        widget.screenId, false);
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

  Future<List<Message>> retrieveAnnouncement() async {
    final Database db = await initializeDB();
    List<Map> list = await db.rawQuery(
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
    return list.cast();
    // return true;
  }

  receiveMessageHandler(args) {
    if (args[5]) {
      signalR.messageList.add(Message(
          name: args[0],
          message: args[1],
          groupName: args[2],
          messageId: args[3],
          messageStatus: args[5],
          isMine: args[0] == widget.name));
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 75,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      deleteMessageFromList(args[3]);
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


  @override
  Widget build(BuildContext context) {
    // if( flg == true && signalR.messageList[0].message != null) {
    return  Container(
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
                    return MessageCard(
                      delete: sendDeleteMessage,
                      messageId: signalR.messageList[i].messageId,
                      sender: signalR.messageList[i].name,
                      groupName: signalR.messageList[i].groupName,
                      text: signalR.messageList[i].message,
                      timestamp: DateTime.now(),
                      isMe: signalR.messageList[i].isMine,
                    );
                  },
                ),
              ),
              globals.messagePermission
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
                                       widget.groupId);
                                  signalR.sendMessage(
                                      widget.name,
                                      txtController.text,
                                      globals.myGroupName,
                                      globals.messageId,
                                      widget.groupId,
                                      true);
                                  sendPushNotification(globals.messageId,widget.groupId,txtController.text,
                                      widget.screenId, true);
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
        ));
    // }else{
    //   return CircularIndicator();
    // }
  }

  @override
  void initState() {

    signalR.connect(receiveMessageHandler);
    // Map<String, dynamic> data = storage.getItem('announcement.json');
    //
    // var announcement =  getAll('1');
    //  // var announcement = getanouncementAll('1');
    //
    // var t = data;
    if (signalR.messageList.length == 0) {
       retrieveAnnouncement();
    }
    // if(data2 != null) {
    //   signalR.messageList.add(Message(
    //       name: 'nhk', message: data2.toString(), isMine: 1 == widget.name));
    // }
  }

  @override
  void dispose() {
    txtController.dispose();
    scrollController.dispose();
    signalR.disconnect();
    super.dispose();
  }

// getanouncementAll  (String s) async {
//    return  await getAll('1');
//  }

}
