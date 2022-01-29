

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'Models/Chat.dart';
import 'db.dart';
import 'errorPage.dart';
import 'globals.dart' as globals;
import 'package:get/get.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

// final ip = '10.1.1.123:81' ;
final ip = '10.1.1.220:5001' ;

Future<String> createLoginState(String userID, String password) async {
  globals.userID = userID;
  // if(userID == '1' && password == '123'){
  //   globals.userID = userID;
  //   return '1';
  // }else{
  //   return '2';
  // }
  try {
    final response = await http.get(Uri.parse(
        'http://'+ ip +'/api/Hrs/LoginCheck?id=' + userID + '&password=' +
            password));
    if (response.statusCode == 200) {
      globals.isLoggedIn = true;
      // var data = json.decode(response.body);
      var data = response.body;
       globals.userID = userID;
      globals.userName = data;
      // final SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('userID', userID);
      // prefs.setString('password', password);
      if(data != '2' ){
        data = '1';
      }
      return data;
    } else {
      globals.isLoggedIn = false;
      throw Exception('Failed');
      // return 3;
    }
  }catch(e){
    //throw Exception('Failed');
    return '3';
  }
}

Future<String> logIn(String userID, String password) async {
  globals.userID = userID;
  // if(userID == '1' && password == '123'){
  //   globals.userID = userID;
  //   globals.messagePermission = true;
  //   globals.mygroupName = 'IT';
  //   globals.userName = "nhk";
  //   return '1';
  // }else{
  //   return '2';
  // }
  try {
    final response = await http.get(Uri.parse(
        'http://'+ ip +'/api/Hrs/logIn?id=' + userID + '&password=' + password));
    if (response.statusCode == 200) {
      globals.show = true;
      LoginData userMap = LoginData.fromJson(jsonDecode(response.body));
      globals.messagePermission = userMap.messagePermission;
      globals.userName = userMap.name;
      globals.myGroupName = userMap.groupName;
      globals.lastMessageId = userMap.lastMessageId;
      saveSettings(userID,password,userMap.name,globals.lastMessageId);
      return userMap.status;
    } else {
      throw Exception('Failed');
    }
  }catch(e){
    // throw Exception('Failed');
    return '3';
  }
}

Future<ProfileData> getUserDetails(String userID) async {
  globals.userID = userID;
  globals.showLoading = true;
   //BuildContext context ;
  try {
    final response = await http.get(Uri.parse(
        'http://'+ ip +'/api/Hrs/getUserDetails?id=' + userID ));
    if (response.statusCode == 200) {
      globals.show = true;
      ProfileData userMap = ProfileData.fromJson(jsonDecode(response.body));
     // Map<String, dynamic> userMap = jsonDecode(response.body);
      //return Profile.fromJson(userMap);
      return userMap;
    } else {
      globals.show = false;
      globals.showLoading = false;
      throw Exception('Failed');
    }
  }catch(e){
    Get.to(ErrorPage());
    globals.showLoading = false;
    globals.show = false;
    throw Exception('Failed');
  }
}

Stream <List<dynamic>?> getAnnouncement(String groupID) async* {
  globals.showLoading = true;
   //BuildContext context ;
  try {
    final response = await http.get(Uri.parse(
        'http://'+ ip +'/api/Hrs/getAnnouncement?groupId=' + groupID ));
    if (response.statusCode == 200) {
      globals.show = true;
      List jsonResponse = json.decode(response.body);
      List announcementMap =  jsonResponse.map((job) => new AnnouncementData.fromJson(job)).toList();

      //
      // return jsonResponse.map((job) => new AnnouncementData.fromJson(job)).toList();

      yield  announcementMap;
    } else {
      globals.show = false;
      globals.showLoading = false;
      throw Exception('Failed');
    }
  }catch(e){
    Get.to(ErrorPage());
    globals.showLoading = false;
    globals.show = false;
    throw Exception('Failed');
  }
}
Future <List<dynamic>?> getMessageDetails(String screenId) async {
  globals.showLoading = true;
   //BuildContext context ;
  try {
    final response = await http.get(Uri.parse(
        'http://'+ ip +'/api/Hrs/getMessageDetails?userId=' + globals.userID + '&screenId=' + screenId));
    if (response.statusCode == 200) {
      globals.show = true;
      List jsonResponse = json.decode(response.body);
      List messageHeadData =  jsonResponse.map((job) => new Chat.fromJson(job)).toList();
      globals.messageDetails = messageHeadData;
      return  messageHeadData;
    } else {
      globals.show = false;
      globals.showLoading = false;
      throw Exception('Failed');
    }
  }catch(e){
    Get.to(ErrorPage());
    globals.showLoading = false;
    globals.show = false;
    throw Exception('Failed');
  }
}

Future<bool> saveProfile(profile) async {
  if( profile == null || globals.saveFlag == false){
    Get.snackbar('Saved', 'no changes found');
    return false;
  }
  globals.saveFlag = false;
  //List<Profile> list = profile;
  //String jsond = jsonEncode(profile);
  final response = await http.post(Uri.parse(
      'http://'+ ip +'/api/Hrs/SaveProfile'),headers:{"Content-Type":"application/json"},body: profile);

  if (response.statusCode == 200) {
    return json.decode(response.body) ;
  } else {
    globals.isLoggedIn = false;
    throw Exception('Failed');
  }
}
Future<bool> sendPushNotification(String messageId,String message,String screenId, bool status) async {

  Map<String, dynamic> notification = {
    "messageId": messageId,
    "senderID": int.parse(globals.userID),
    "message": message,
    "priority": '1',
    "screenId": screenId,
    "groupId": 1,
    "status":status,
  };
  var data = jsonEncode(notification);

  final response = await http.post(Uri.parse(
      'http://'+ ip +'/api/Hrs/pushNotification'),headers:{"Content-Type":"application/json"},body: data);

  if (response.statusCode == 200) {
    return json.decode(response.body) ;
  } else {
    globals.isLoggedIn = false;
    throw Exception('Failed');
  }
}

Future<bool> logFirebaseToken(token) async {

  final response = await http.post(Uri.parse(
      'http://'+ ip +'/api/Hrs/logFirebaseToken'),headers:{"Content-Type":"application/json"},body: token);

  if (response.statusCode == 200) {
    return json.decode(response.body) ;
  } else {
    globals.isLoggedIn = false;
    throw Exception('Failed');
  }
}


class LoginCheckResponse{

  bool status = false;

  LoginCheckResponse.fromJson(Map<String, dynamic> json) {
    status = json[0] == null ? "NULL" : json[0];
  }
}

class LoginData{
  int lastMessageId = 0;
  String name = "NULL";
  bool messagePermission = false;
  String status = '0';
  String groupName = "null";

  LoginData(
      {required this.lastMessageId,required this.name,required this.messagePermission,required this.status,required this.groupName});

  Map<String, dynamic> toJson() {
    return {
      'lastMessageId' : lastMessageId,
      'name': name,
      'messagePermission': messagePermission,
      'status': status,
      'groupName' : groupName,
    };
  }

  LoginData.fromJson(Map<String, dynamic> json) {
    lastMessageId = json['lastMessageId'] == null ? 0 : json['lastMessageId'];
    name = json['name'] == null ? "NULL" : json['name'];
    messagePermission = json['messagePermission'] == null ? "NULL" : json['messagePermission'];
    status = json['status'] == null ? "NULL" : json['status'];
    groupName = json['groupName'] == null ? "NULL" : json['groupName'];
  }

}

class ProfileData{
  int id = 0;
  String name = "NULL";
  int age = 0;
  String email = "NULL";
  String department = "NULL";

  ProfileData(
      {required this.id,required this.name,required this.age,required this.email,required this.department});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'email': email,
      'department': department,
    };
  }

  ProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? "NULL" : json['id'];
    name = json['name'] == null ? "NULL" : json['name'];
    age = json['age'] == null ? "NULL" : json['age'];
    email = json['email'] == null ? "NULL" : json['email'];
    department = json['department'] == null ? "NULL" : json['department'];
  }

}
class AnnouncementData{
  int id = 0;
  String name = "NULL";
  String message =  "NULL";
  int groupId = 0;
  int priority = 0;
  int senderID = 0 ;


  AnnouncementData(
      {required this.id,required this.senderID,required this.name,required this.message,required this.groupId,required this.priority});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'message': message,
      'groupId': groupId,
      'priority': priority,
    };
  }

  AnnouncementData.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? "NULL" : json['id'];
    senderID = json['senderID'] == null ? "NULL" : json['senderID'];
    name = json['name'] == null ? "NULL" : json['name'];
    message = json['message'] == null ? "NULL" : json['message'];
    groupId = json['groupId'] == null ? "NULL" : json['groupId'];
    priority = json['priority'] == null ? "NULL" : json['priority'];
  }

}
class MessageHeadData{
  String groupName =  "NULL";
  String lastMessage =  "NULL";
  String messageTime =  "NULL";
  String imagePath =  "NULL";
  bool isActive =  false ;


  MessageHeadData(
      {required this.groupName,required this.lastMessage,required this.messageTime,required this.imagePath,required this.isActive});

  // Map<String, dynamic> toJson() {
  //   return {
  //     'name': name,
  //     'message': message,
  //     'groupId': groupId,
  //     'priority': priority,
  //   };
  // }

  MessageHeadData.fromJson(Map<String, dynamic> json) {
    groupName = json['groupName'] == null ? "NULL" : json['groupName'];
    lastMessage = json['lastMessage'] == null ? "NULL" : json['lastMessage'];
    messageTime = json['messageTime'] == null ? "NULL" : json['messageTime'];
    imagePath = json['imagePath'] == null ? "NULL" : json['imagePath'];
    isActive = json['isActive'] == null ? false : json['isActive'];
  }

}

class LoginResponse {
  String token = "NULL";
  int id = 0;
  String name = "NULL";
  String password = "NULL";
  String createdDate = TimeOfDay.now().toString();

  LoginResponse(
      {required this.token,required this.id,required this.name,required this.password,required this.createdDate});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'] == null ? "NULL" : json['token'];
    id = json['id'] == null ? "NULL" : json['id'];
    name = json['name'] == null ? "NULL" : json['name'];
    password = json['password'] == null ? "NULL" : json['password'];
    createdDate = json['createdDate'] == null ? "NULL" : json['createdDate'];
  }
}

class Notification{
  String message =  "NULL";
  String groupId = '0';
  String priority = '0';
  int senderID = 0 ;

  Notification(
      {required this.message,required this.groupId,required this.priority,required this.senderID});

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'groupId': groupId,
      'priority': priority,
      'senderID':senderID
    };
  }

  Notification.fromJson(Map<String, dynamic> json) {
    message = json['message'] == null ? "NULL" : json['message'];
    groupId = json['groupId'] == null ? "NULL" : json['groupId'];
    priority = json['priority'] == null ? "NULL" : json['priority'];
    senderID = json['senderID'] == null ? "NULL" : json['senderID'];
  }

}
