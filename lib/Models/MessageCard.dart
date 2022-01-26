import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:logindemo/ChatScreen.dart';


import '../db.dart';

class MessageCard extends StatefulWidget {
  late final ValueChanged<String> delete;

  MessageCard(
      {required this.messageId,
      this.sender,
      this.text,
      this.timestamp,
      this.isMe,
      required this.groupName,
      required this.delete});

  final String messageId;
  final String? sender;
  final String? text;
  final DateTime? timestamp;
  final bool? isMe;
  final String groupName;
  var cardColor;

  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final ChatScreen cs = new ChatScreen();

  @override
  Widget build(BuildContext context) {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(widget.timestamp!.second * 1000);
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            widget.isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          // Text(
          //   "$sender",
          //   style: TextStyle(fontSize: 12.0, color: Colors.black54),
          // ),

          InkWell(
            onLongPress: () {
              if (widget.isMe!) {
                Get.defaultDialog(
                    confirm: TextButton(
                        onPressed: () {
                          widget.delete(widget.messageId);
                          Navigator.pop(context);
                          deleteMessage(widget.messageId);
                        },
                        child: Text(
                          'OK',
                        ),
                        style: ButtonStyle(
                            // side: MaterialStateProperty.all(
                            //     BorderSide(width: 2, color: Colors.blueAccent)),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.purple),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 45)),
                            textStyle: MaterialStateProperty.all(
                                TextStyle(fontSize: 15)))),
                    cancel: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            widget.cardColor = Colors.white;
                          });
                        },
                        child: Text(
                          'Cancel',
                        ),
                        style: ButtonStyle(
                            // side: MaterialStateProperty.all(
                            //     BorderSide(width: 2, color: Colors.blueAccent)),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.purple),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 40)),
                            textStyle: MaterialStateProperty.all(
                                TextStyle(fontSize: 15)))),
                    title: "Delete message",
                    middleText: "are you sure you want to delete");
                setState(() {
                  widget.cardColor = Colors.red;
                });
              }
            },
            child: Card(
              color: widget.cardColor,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Container(
                    child: Container(
                      decoration: new BoxDecoration(color: Colors.blueAccent),
                      child: ListTile(
                        // IconButton(
                        //   onPressed: (){
                        //   },
                        //   icon:Icon(Icons.delete, size: 20),
                        //   color: Colors.red,
                        // ),
                        // leading: const Icon(Icons.delete,size: 20),
                        //  onTap: () {},
                        // leading: Icon(Icons.arrow_drop_down_circle),
                        title: Text(widget.groupName),
                        subtitle: Text(
                          widget.sender!,
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      widget.text!,
                      style: TextStyle(color: Colors.black.withOpacity(1.0)),
                    ),
                  ),
                  // ButtonBar(
                  //   alignment: MainAxisAlignment.end,
                  //   children: [
                  //     IconButton(
                  //       onPressed: () {},
                  //       icon: Icon(Icons.delete, size: 15),
                  //       color: Colors.red,
                  //     ),
                  //   ],
                  // ),
                  // Image.asset('assets/card-sample-image.jpg'),
                  // Image.asset('assets/card-sample-image-2.jpg'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
