
class Message {
  String messageId;
  String name;
  String message;
  bool isMine = false;
  String groupName;
  bool messageStatus;

  Message({required this.messageId, required this.name, required this.message, required this.groupName,this.isMine = false,required this.messageStatus});
}