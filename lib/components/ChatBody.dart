import 'package:pasons_HR/Models/Message.dart';
import 'package:pasons_HR/Models/MessageDetails.dart';

import '../ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:pasons_HR/globals.dart' as globals;
import '../SignalRHelper.dart';
import '../api.dart';
import '../globals.dart';
import 'ChatCard.dart';

class ChatBody extends StatefulWidget {
  final screenId;
  final screen;
  final isChat;
  var messageDetailsList = <MessageDetails>[];


  @override
  _ChatBodyState createState() => _ChatBodyState();

  ChatBody({Key? key, this.screenId, this.screen,this.isChat}) : super(key: key);
}

class _ChatBodyState extends State<ChatBody> {
  SignalRHelper signalR = new SignalRHelper();

  // refresh() async {
  //   if (widget.isChat) {
  //     await getMessageChatDetails(widget.screenId);
  //   } else {
  //     await getMessageGroupDetails(widget.screenId);
  //   }
  //   setState(() {});
  // }

  @override
  void initState() {
    retrieveMessageDetails(widget.screenId,widget.isChat);
     signalR.getMessageDetails(receiveMessageDetailsHandler);
    // signalR.connect(receiveMessageDetailsHandler);

    // signalR.sendMessage("Haadhi", "test","it","1-07","1",true);
    // super.initState();
  }

  @override
  void dispose() {
    signalR.disconnect();
    super.dispose();
  }


  receiveMessageHandler(args) {
    if (args[5]) {
      signalR.messageList.add(Message(
          name: args[0],
          message: args[1],
          groupName: args[2],
          messageId: args[3],
          messageStatus: args[5],
          isMine: args[0] == "Haadhi"));
    }
    if (this.mounted) {
      setState(() {});
    }
  }



  receiveMessageDetailsHandler(args) {
     // widget.messageDetailsList.clear();
     widget.messageDetailsList[widget.messageDetailsList.indexWhere((element) => element.groupId == args[0])] = MessageDetails(
         groupId: args[0],
         groupName: args[1],
         lastMessage: args[2],
         messageTime: args[3],
         imagePath: args[4],
         isActive:args[5]);
    if (this.mounted) {
      setState(() {});
    }
  }

  Future  retrieveMessageDetails(screenId,isChat) async {
    var messageDetailsList;
    if(isChat){
      messageDetailsList = await getMessageChatDetails(screenId);
    }else{
      messageDetailsList = await getMessageGroupDetails(screenId);
    }
    setState(()   {
      int i = 0;
      for (var message in messageDetailsList) {
        widget.messageDetailsList.add(MessageDetails(
          groupId: message.groupId,
          groupName: message.groupName,
          lastMessage: message.lastMessage,
          messageTime: message.messageTime,
          imagePath: message.imagePath,
          isActive:message.isActive),
        );
      }
    });

    setState(() {
      // widget.messageDetailsList.single;
    });
    // });
    // return list.cast();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            // Container(
            //   padding: EdgeInsets.fromLTRB(
            //       kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
            //   color: kPrimaryColor,
            //   // child: Row(
            //   //   children: [
            //   //     FillOutlineButton(press: () {}, text: "Recent Message"),
            //   //     SizedBox(width: kDefaultPadding),
            //   //     FillOutlineButton(
            //   //       press: () {},
            //   //       text: "Active",
            //   //       isFilled: false,
            //   //     ),
            //   //   ],
            //   // ),
            // ),
            Expanded(
              child: ListView.builder(
                itemCount: messageDetails.length,
                itemBuilder: (context, index) => ChatCard(
                  // chat: chatsData[index],
                  messageDetails: widget.messageDetailsList[index],
                  press: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          name: globals.userName,
                          screenId: widget.screenId,
                          screen:
                              messageDetails[index].groupName + '  ' + widget.screen,
                          groupId: messageDetails[index].groupId),
                    ),
                  ),
                        // .then((value) =>  refresh())
                ),
              ),
            ),
          ],
        );
  }
}
