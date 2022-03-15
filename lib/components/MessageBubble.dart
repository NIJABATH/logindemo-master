import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'colors.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.messageId,
    this.sender,
    this.text,
    this.timestamp,
    this.isMe,
    required this.groupName,
    required this.delete,
    this.time});

  final String messageId;
  final String? sender;
  final String? text;
  final DateTime? timestamp;
  final bool? isMe;
  final String groupName;
  var cardColor;
  late final ValueChanged<String> delete;
  final time;


  @override
  Widget build(BuildContext context) {
    // final dateTime =
    // DateTime.fromMillisecondsSinceEpoch(timestamp!.second * 1000);
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
        isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            isMe! ?"":sender!,
            style: TextStyle(fontSize: 12.0, color: Colors.white),
          ),
          Material(
            borderRadius: isMe!
                ? BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            )
                : BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color:
            isMe! ? PalletteColors.primaryGrey : PalletteColors.lightBlue,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment:
                isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    text!,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: isMe! ? Colors.white : Colors.black54,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                             time,
                      style: TextStyle(
                        fontSize: 9.0,
                        color: isMe!
                            ? Colors.white.withOpacity(0.5)
                            : Colors.black54.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
