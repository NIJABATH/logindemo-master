import 'package:flutter/material.dart';

import 'SignalRHelper.dart';
//import 'package:path_provider/path_provider.dart';

const gradientPurple = Color(0xFFD14E93);
const gradientPink = Color(0xFFF95767);

final listTransparentBg = Colors.white.withOpacity(0.12);

//final storageDir = getApplicationDocumentsDirectory();

 bool isLoggedIn = false;
 bool loaded = false;
 bool showLoading = false;
 bool saveFlag  = false;
 bool show = false;
 String userID = '' ;
 String password = '' ;
 // String userID2  = '0';
 String userName  = '0';
 bool messagePermission = false;
 String myGroupName = 'null';
 int lastMessageId = 0;
 String messageId = 'null';
 // SignalRHelper signalR = new SignalRHelper();


var text = [];