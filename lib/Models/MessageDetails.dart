
class MessageDetails {
  String groupId = "";
  String groupName = "";
  String lastMessage = "";
  String messageTime = "";
  String imagePath = "";
  bool isActive = false ;
  String receiverId = "" ;
  String senderId = "";

  MessageDetails({required this.groupId, required this.groupName, required this.lastMessage,
    required this.messageTime,required this.imagePath,required this.isActive,required this.receiverId,required this.senderId});
}