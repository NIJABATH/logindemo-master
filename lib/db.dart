import 'dart:convert';

import 'package:localstorage/localstorage.dart';
import 'package:localstore/localstore.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'globals.dart' as globals;

final db = Localstore.instance;
final LocalStorage storage = new LocalStorage('announcement.json');

Future<Database> initializeDB() async {
  String path = await getDatabasesPath();
  return openDatabase(
    join(path, 'pasonsHr.db'),
    onCreate: (database, version) async {
      await database.execute(
        "CREATE TABLE textMessage(id INTEGER PRIMARY KEY AUTOINCREMENT,messageId TEXT NOT NULL, name TEXT NOT NULL,message TEXT NOT NULL,screenId int NOT NULL,groupName TEXT NOT NULL,groupId TEXT NOT NULL)",
      );
      await database.execute(
        "CREATE TABLE settings(id INTEGER PRIMARY KEY AUTOINCREMENT, userId TEXT NOT NULL,password TEXT NOT NULL,name TEXT NOT NULL,myGroupName TEXT,lastMessageId int)",
      );
    },
    version: 1,
  );
}

void saveMessage(String messageId, String name, String? message,
    String screenId, String groupName , String groupId) async {
  // int result = 0;
  final Database db = await initializeDB();
  // result = await db.insert('announcement', message.toMap());
  int result = await db.rawInsert(
      'INSERT INTO textMessage(messageId,name, message,screenId,groupName,groupId) VALUES("' +
          messageId +
          '","' +
          name +
          '","' +
          message! +
          '","' +
          screenId +
          '","' +
          groupName +
          '","' +
           groupId +
          '")');
}

void saveSettings(
    String userId, String password, String name,String myGroupName, int lastMessageId) async {
  int result = 0;
  final Database db = await initializeDB();
  result = await db.rawInsert(
      'INSERT INTO settings(userId,password,name,myGroupName,lastMessageId) VALUES("' +
          userId +
          '","' +
          password +
          '","' +
          name +
          '","' +
          myGroupName +
          '","' +
          lastMessageId.toString() +
          '")');
}
 deleteSettings() async {
  final Database db = await initializeDB();
  return  await db.rawDelete(
      'DELETE FROM settings ');
}

getSettings() async {
  final Database db = await initializeDB();
  List<Map> list = await db.rawQuery('SELECT * FROM settings');
  if (list.isEmpty) {
    return false;
  } else {
    globals.userID = list[0]["userId"];
    globals.password = list[0]["password"];
    globals.userName = list[0]["name"];
    globals.myGroupName = list[0]["myGroupName"];
    globals.lastMessageId = list[0]["lastMessageId"];
    return true;
  }
}

getAll(String groupID) async {
  Map<String, dynamic> messages =
      await json.decode(storage.getItem('messages'));
  globals.text[0] = messages['message'];
}

Future<bool> deleteMessage(String id) async {
  final Database db = await initializeDB();
  await db.rawDelete('Delete from textMessage where messageId = "' + id + '"');
  return true;
}
