import 'package:logindemo/Models/Chat.dart';
import '../ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:logindemo/globals.dart' as globals;
import 'ChatCard.dart';

class ChatBody extends StatelessWidget {

  ChatBody(this.screenId, this.screen);

  final screenId;
  final screen;

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
            itemCount: chatsData.length,
            itemBuilder: (context, index) => ChatCard(
              chat: chatsData[index],
              press: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    name: globals.userName,
                    screenId:screenId,
                    screen:screen,),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}