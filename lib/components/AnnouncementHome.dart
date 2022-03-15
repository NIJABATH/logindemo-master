import 'dart:async';
import 'package:pasons_HR/Models/MessageDetails.dart';
import 'package:pasons_HR/globals.dart' as globals;
import '../SignalRHelper.dart';
import '../api.dart';
import 'ChatBody.dart';
import 'package:flutter/material.dart';
StreamController <int> streamController = StreamController<int>.broadcast();


class AnnouncementHome extends StatefulWidget {
  final screenId;
  final screen;
  var messageDetailsList = <MessageDetails>[];
  @override
  _AnnouncementHomeState createState() => _AnnouncementHomeState();

  AnnouncementHome({Key? key, this.screenId, this.screen}) : super(key: key);
}

class _AnnouncementHomeState extends State<AnnouncementHome> {
  bool _showLoading = true;
  SignalRHelper signalR = new SignalRHelper();

  @override
  void initState() {
    retrieveMessageDetails(widget.screenId);
  }

  @override
  void dispose() {
    signalR.disconnect();
    globals.messageDetails = <MessageDetails>[];
    super.dispose();
  }

  Future retrieveMessageDetails(screenId) async {
    var messageDetailsList;
    widget.messageDetailsList.clear();
    messageDetailsList = await getMessageGroupDetails(screenId);
    for (var message in messageDetailsList) {
      widget.messageDetailsList.add(
        MessageDetails(
            groupId: message.groupId,
            groupName: message.groupName,
            lastMessage: message.lastMessage,
            messageTime: message.messageTime,
            imagePath: message.imagePath,
            isActive: message.isActive,
            receiverId: message.receiverId,
            senderId: message.senderId),
      );
    }
    globals.messageDetailsList = widget.messageDetailsList;
    streamController.add(1);
    signalR.getMessageDetails(receiveMessageDetailsHandler);
    setState(() {
      _showLoading = false;
    });
    return true;
  }

  receiveMessageDetailsHandler(args) {
    // widget.messageDetailsList.clear();
    widget.messageDetailsList[widget.messageDetailsList
        .indexWhere((element) => element.groupId == args[0])] =
        MessageDetails(
            groupId: args[0],
            groupName: args[1],
            lastMessage: args[2],
            messageTime: args[3],
            imagePath: args[4],
            isActive: args[5],
            receiverId: args[6].toString(),
            senderId: args[7]);
    globals.messageDetailsList = widget.messageDetailsList;

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
            screen: widget.screen,isChat:false,stream: streamController.stream),
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
