import 'package:pasons_HR/Models/MessageDetails.dart';

import '../ChatScreen.dart';
import '../Constants.dart';
import '../SignalRHelper.dart';
import '../api.dart';
import 'ChatBody.dart';
import 'package:flutter/material.dart';

class ChatHome extends StatefulWidget {
  final screenId;
  final screen;
  // var messageDetailsList = <MessageDetails>[];

  @override
  _ChatsHomeState createState() => _ChatsHomeState();

  ChatHome({Key? key, this.screenId, this.screen}) : super(key: key);
}

class _ChatsHomeState extends State<ChatHome> {
  int _selectedIndex = 1;
  // SignalRHelper signalR = new SignalRHelper();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: buildAppBar(),
              body:   TabBarView(
                  children: [ChatBody(screenId: widget.screenId, screen: widget.screen,isChat:false),
                ChatBody(screenId: widget.screenId, screen: widget.screen,isChat:true)
                    // ChatScreen(screenId: widget.screenId, screen: widget.screen,messageId: "1-1",name: "nnn",groupId: 1,),
                  ])
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () {},
              //   backgroundColor: kPrimaryColor,
              //   child: Icon(
              //     Icons.person_add_alt_1,
              //     color: Colors.white,
              //   ),
              // ),
              // bottomNavigationBar: buildBottomNavigationBar(),
            )),
      debugShowCheckedModeBanner: false,
    );
  }

  // @override
  // void initState() {
  //   signalR.getMessageDetails(receiveMessageDetailsHandler);
  //   super.initState();
  // }
  //
  // @override
  // void dispose() {
  //   signalR.disconnect();
  //   super.dispose();
  // }
  //
  //
  // receiveMessageDetailsHandler(args) {
  //   widget.messageDetailsList.clear();
  //   widget.messageDetailsList.add(MessageDetails(
  //       groupId: args[0],
  //       groupName: args[1],
  //       lastMessage: args[2],
  //       messageTime: args[3],
  //       imagePath: args[4],
  //       isActive:args[5]),);
  //   if (this.mounted) {
  //     setState(() {});
  //   }
  // }
  //
  // Future retrieveMessageDetails(screenId) async {
  //
  //    var messageDetailsList = await getMessageGroupDetails(screenId);
  //   setState(() {
  //     int i = 0;
  //     widget.messageDetailsList.add(MessageDetails(
  //         groupId: messageDetailsList![0],
  //         groupName: messageDetailsList[1],
  //         lastMessage: messageDetailsList[2],
  //         messageTime: messageDetailsList[3],
  //         imagePath: messageDetailsList[4],
  //         isActive:messageDetailsList[5]),);
  //   });
  //   // setState(() {
  //   //   flg = true;
  //   // });
  //   // });
  //   // return list.cast();
  //   return true;
  // }

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
