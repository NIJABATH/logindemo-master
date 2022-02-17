import 'package:pasons_HR/Models/Message.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'example.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE announcement(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,message TEXT NOT NULL,groupid int NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertAnnouncement(String message,int groupid) async {
    int result = 0;
    final Database db = await initializeDB();
      // result = await db.insert('announcement', message.toMap());
      result = await db.rawInsert(
          'INSERT INTO announcement(name, message,groupid) VALUES("some name",'+ message+','+ groupid.toString() +')');

    return result;
    }

  Future<List<Message>> retrievAnnouncement(int groupid) async {
    final Database db = await initializeDB();
    List<Map> list = await db.rawQuery('SELECT * FROM Test where groupid =' + groupid.toString() );
    final List<Map<String, Object?>> queryResult = await db.query('users');
    return list.cast();
  }


}

//   await database.transaction((txn) async {
//   int id1 = await txn.rawInsert(
//   'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
// });


