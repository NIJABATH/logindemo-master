import 'dart:async';

import 'package:pasons_HR/Models/MessageDetails.dart';
import 'package:pasons_HR/globals.dart' as globals;
import '../SignalRHelper.dart';
import '../api.dart';
import '../service.dart';
import 'ChatBody.dart';
import 'package:flutter/material.dart';
// StreamController <List<MessageDetails>> streamController = StreamController<List<MessageDetails>>.broadcast();
StreamController <int> streamController = StreamController<int>.broadcast();


class ChatHome extends StatefulWidget {
  final screenId;
  final screen;
  var messageDetailsList = <MessageDetails>[];
  var messageChatDetailsList = <MessageDetails>[];

  @override
  _ChatsHomeState createState() => _ChatsHomeState();

  ChatHome({Key? key, this.screenId, this.screen}) : super(key: key);
}

class _ChatsHomeState extends State<ChatHome> {
  int _selectedIndex = 1;
  SignalRHelper signalR = new SignalRHelper();
  bool _showLoading = true;
   // ChatBody  _chatBody = new ChatBody();

  @override
  void initState() {
    retrieveMessageDetails(widget.screenId);
    // signalR.connect(receiveMessageDetailsHandler);

    // signalR.sendMessage("Haadhi", "test","it","1-07","1",true);
    // super.initState();
  }

  @override
  void dispose() {
    // signalR.disconnect();
    globals.messageDetailsList = <MessageDetails>[];
    globals.messageChatDetailsList = <MessageDetails>[];
    super.dispose();
  }

  receiveMessageDetailsHandler(args) {
    // widget.messageDetailsList.clear();
    var _receiverId = args[6].toString();
    if(args[6] == 0) {
      widget.messageDetailsList[widget.messageDetailsList
          .indexWhere((element) => element.groupId == args[0])] =
          MessageDetails(
              groupId: args[0],
              groupName: args[1],
              lastMessage: args[2],
              messageTime: args[3],
              imagePath: args[4],
              isActive: args[5],
              receiverId: _receiverId,
              senderId: args[7]);
      globals.messageDetailsList = widget.messageDetailsList;
    }else{

      widget.messageChatDetailsList[widget.messageChatDetailsList
          .indexWhere((element) => element.receiverId == _receiverId)] =
          MessageDetails(
              groupId: args[0],
              groupName: args[1],
              lastMessage: args[2],
              messageTime: args[3],
              imagePath: args[4],
              isActive: args[5],
              receiverId: _receiverId,
             senderId: args[7]);
      globals.messageChatDetailsList = widget.messageChatDetailsList;

    }
    streamController.add(1);

    // _chatBody.refresh();
    // if (this.mounted) {
    //   setState(() {});
    // }
  }

  Future retrieveMessageDetails(screenId) async {
    var messageDetailsList;
    var messageChatDetailsList;
    widget.messageDetailsList.clear();
    widget.messageChatDetailsList.clear();
      messageDetailsList = await getMessageGroupDetails(screenId);
      messageChatDetailsList = await getMessageChatDetails(screenId);

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
              senderId: message.senderId
          ),
        );
      }
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
              senderId: message.senderId)
        );
      }
      streamController.add(1);
    globals.messageDetailsList = widget.messageDetailsList;
    globals.messageChatDetailsList = widget.messageChatDetailsList;
    signalR.getMessageDetails(receiveMessageDetailsHandler);
    setState(() {
      _showLoading = false;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_showLoading) {
      return  DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: buildAppBar(),
                body: TabBarView(
                    children: [
                      ChatBody(screenId: widget.screenId,
                          screen: widget.screen,isChat:false,stream: streamController.stream),
                      ChatBody(screenId: widget.screenId,
                          screen: widget.screen,isChat:true,stream: streamController.stream)
                      ,
                      // stream: streamController.stream
                    ])
            ),
        // debugShowCheckedModeBanner: false,
      );
    }else{
      return CircularIndicator();
    }
  }


  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.messenger), label: "Chats"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "People"),
        BottomNavigationBarItem(icon: Icon(Icons.call), label: "Calls"),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 14,
            backgroundImage: AssetImage("assets/images/user_2.png"),
          ),
          label: "Profile",
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(widget.screen),
      bottom: const TabBar(
        tabs: [
          Tab(text: "Group"),
          Tab(text: "Chat"),
        ],
      ),
      // actions: [
      //   IconButton(
      //     icon: Icon(Icons.search),
      //     onPressed: () {},
      //   ),
      // ],
    );
  }
}
