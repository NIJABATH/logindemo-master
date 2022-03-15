class Chat {
  String groupId =  "";
  String groupName =  "";
  String lastMessage =  "";
  String messageTime =  "";
  String imagePath =  "NULL";
  bool isActive =  false ;
  String receiverId = "0";
  String senderId = "0";

  Chat({ required this.groupId,required this.groupName,required this.lastMessage,
    required this.messageTime,required this.imagePath,required this.isActive,required this.senderId });

  Chat.fromJson(Map<String, dynamic> json) {
    groupId = json['groupId'] == null ? "" : json['groupId'].toString();
    groupName = json['groupName'] == null ? "" : json['groupName'];
    lastMessage = json['lastMessage'] == null ? "" : json['lastMessage'];
    messageTime = json['messageTimeAgo'] == null ? "" : json['messageTimeAgo'];
    imagePath = json['imagePath'] == null ? "NULL" : json['imagePath'];
    isActive = json['isActive'] == null ? false : json['isActive'];
    receiverId = json['receiverId'].toString() == null ? "0" : json['receiverId'].toString();
    senderId = json['senderId'] == null ? "0" : json['senderId'].toString();
  }
}
//
// List chatsData = [
//   Chat(
//     name: "Jenny Wilson",
//     lastMessage: "Hope you are doing well...",
//     image: "assets/images/user.png",
//     time: "3m ago",
//     isActive: false,
//   ),
//   Chat(
//     name: "Esther Howard",
//     lastMessage: "Hello Abdullah! I am...",
//     image: "assets/images/user_2.png",
//     time: "8m ago",
//     isActive: true,
//   ),
//   Chat(
//     name: "Ralph Edwards",
//     lastMessage: "Do you have update...",
//     image: "assets/images/user_3.png",
//     time: "5d ago",
//     isActive: false,
//   ),
//   Chat(
//     name: "Jacob Jones",
//     lastMessage: "You’re welcome :)",
//     image: "assets/images/user_4.png",
//     time: "5d ago",
//     isActive: true,
//   ),
//   Chat(
//     name: "Albert Flores",
//     lastMessage: "Thanks",
//     image: "assets/images/user_5.png",
//     time: "6d ago",
//     isActive: false,
//   ),
//   Chat(
//     name: "Jenny Wilson",
//     lastMessage: "Hope you are doing well...",
//     image: "assets/images/user.png",
//     time: "3m ago",
//     isActive: false,
//   ),
//   Chat(
//     name: "Esther Howard",
//     lastMessage: "Hello Abdullah! I am...",
//     image: "assets/images/user_2.png",
//     time: "8m ago",
//     isActive: true,
//   ),
//   Chat(
//     name: "Ralph Edwards",
//     lastMessage: "Do you have update...",
//     image: "assets/images/user_3.png",
//     time: "5d ago",
//     isActive: false,
//   ),
// ];