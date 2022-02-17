
class MessageDetails {
  String groupId = "";
  String groupName = "";
  String lastMessage = "";
  String messageTime = "";
  String imagePath = "";
  bool isActive = false ;

  MessageDetails({required this.groupId, required this.groupName, required this.lastMessage,
    required this.messageTime,required this.imagePath,required this.isActive});
}