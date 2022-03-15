import 'dart:async';
import 'package:pasons_HR/Models/MessageDetails.dart';
import '../ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:pasons_HR/globals.dart' as globals;
import '../SignalRHelper.dart';
import 'ChatCard.dart';

// StreamController <int> streamController = StreamController<int>();

class ChatBody extends StatefulWidget {
  final screenId;
  final screen;
  final isChat;
  final Stream<int> stream;
  var messageDetailsList = <MessageDetails>[];
  @override
  _ChatBodyState createState() => _ChatBodyState();

  ChatBody({Key? key, this.screenId, this.screen,this.isChat,required this.stream})
      : super(key: key);
  // void refresh() {
  //   _ChatBodyState.refresh();
  // }

// @override
//   Widget build(BuildContext context){
//   return MeterialApp(
//    Home:_ChatBodyState(StreamController.stream);
//   );
// }
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
    StreamController controller = StreamController();
    controller.addStream(widget.stream);
    super.initState();
    if(!controller.hasListener) {
      widget.stream.listen((list) {
        refresh();
      });
    }
  }

  // @override
  // void dispose() {
  //   signalR.disconnect();
  //   super.dispose();
  // }

  void refresh(){
    if (this.mounted) {
          setState(() {
            // widget.messageDetailsList = widget.isChat?globals.messageDetailsList:globals.messageChatDetailsList;
          });
        }
  }

  // receiveMessageDetailsHandler(args) {
  //   // widget.messageDetailsList.clear();
  //   widget.messageDetailsList[widget.messageDetailsList
  //           .indexWhere((element) => element.groupId == args[0])] =
  //       MessageDetails(
  //           groupId: args[0],
  //           groupName: args[1],
  //           lastMessage: args[2],
  //           messageTime: args[3],
  //           imagePath: args[4],
  //           isActive: args[5]);
  //   if (this.mounted) {
  //     setState(() {});
  //   }
  // }

  // Future retrieveMessageDetails(screenId, isChat) async {
  //   var messageDetailsList;
  //   widget.messageDetailsList.clear();
  //   if (isChat) {
  //     messageDetailsList = await getMessageChatDetails(screenId);
  //   } else {
  //     messageDetailsList = await getMessageGroupDetails(screenId);
  //   }
  //   setState(() {
  //     int i = 0;
  //     for (var message in messageDetailsList) {
  //       widget.messageDetailsList.add(
  //         MessageDetails(
  //             groupId: message.groupId,
  //             groupName: message.groupName,
  //             lastMessage: message.lastMessage,
  //             messageTime: message.messageTime,
  //             imagePath: message.imagePath,
  //             isActive: message.isActive),
  //       );
  //     }
  //   });
  //
  //   setState(() {
  //     // widget.messageDetailsList.single;
  //   });
  //   // });
  //   // return list.cast();
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    widget.messageDetailsList = widget.isChat?globals.messageChatDetailsList:globals.messageDetailsList;

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
        child:ListView.builder(
        itemCount: widget.messageDetailsList.length,
        itemBuilder: (context, index) =>
            ChatCard(
              // chat: chatsData[index],
              messageDetails: widget.messageDetailsList[index],
              press: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(
                            name: globals.userName,
                            screenId: widget.screenId,
                            screen: widget.messageDetailsList[index].groupName,
                                // + '  ' + widget.screen,
                            groupId: widget.messageDetailsList[index].groupId,
                            receiverId: widget.messageDetailsList[index]
                                .receiverId,
                              senderID:widget.messageDetailsList[index].senderId,stream:globals.streamController.stream
                          ),
                    ),
                  ),
              // .then((value) =>  refresh())
            ),
      )
      )
      ]
    );
  }
}
