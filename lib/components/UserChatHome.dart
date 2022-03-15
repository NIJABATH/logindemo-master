import 'dart:async';
import 'package:pasons_HR/Models/MessageDetails.dart';
import 'package:pasons_HR/globals.dart' as globals;
import '../SignalRHelper.dart';
import '../api.dart';
import 'ChatBody.dart';
import 'package:flutter/material.dart';
StreamController <int> streamController = StreamController<int>.broadcast();


class UserChatHome extends StatefulWidget {
  final screenId;
  final screen;
  var messageChatDetailsList = <MessageDetails>[];
  @override
  _UserChatsHomeState createState() => _UserChatsHomeState();

  UserChatHome({Key? key, this.screenId, this.screen}) : super(key: key);
}

class _UserChatsHomeState extends State<UserChatHome> {
  bool _showLoading = true;
  SignalRHelper signalR = new SignalRHelper();

  @override
  void initState() {
    retrieveMessageDetails(widget.screenId);
  }

  @override
  void dispose() {
    signalR.disconnect();
    globals.messageChatDetailsList = <MessageDetails>[];
    super.dispose();
  }

  Future retrieveMessageDetails(screenId) async {
    var messageDetailsList;
    var messageChatDetailsList;
    widget.messageChatDetailsList.clear();
    messageChatDetailsList = await getMessageChatDetails(screenId);
    for (var message in messageChatDetailsList) {
      widget.messageChatDetailsList.add(
        MessageDetails(
            groupId: message.groupId,
            groupName: message.groupName,
            lastMessage: message.lastMessage,
            messageTime: message.messageTime,
            imagePath: message.imagePath,
            isActive: message.isActive,
            receiverId: message.receiverId,
            senderId: message.senderId
        ),
      );
    }
    streamController.add(1);
    globals.messageChatDetailsList = widget.messageChatDetailsList;
    signalR.getMessageDetails(receiveMessageDetailsHandler);
    setState(() {
      _showLoading = false;
    });
    return true;
  }

  receiveMessageDetailsHandler(args) {
    // widget.messageDetailsList.clear();
      widget.messageChatDetailsList[widget.messageChatDetailsList
          .indexWhere((element) => element.receiverId == args[6])] =
          MessageDetails(
              groupId: args[0],
              groupName: args[1],
              lastMessage: args[2],
              messageTime: args[3],
              imagePath: args[4],
              isActive: args[5],
              receiverId: args[6].toString(),
              senderId: args[7]);
      globals.messageChatDetailsList = widget.messageChatDetailsList;

        streamController.add(1);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
              appBar: buildAppBar(),
              body:
                ChatBody(
                    screenId: widget.screenId,
                    screen: widget.screen,isChat:true,stream: streamController.stream),
              ),
      debugShowCheckedModeBanner: false,
    );
  }
  AppBar buildAppBar() {
    return AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.screen),
    );
  }
}
