import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:word_game/data/my_data.dart';

final String TableName = 'MyWord';

class LocalCRUD {
  // static final LocalCRUD _db = LocalCRUD();

  // //factory instance를 한번만 만든다는데?
  // factory LocalCRUD() => _db;

  Future<Database> get database async {
    Database _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'MyWordsDB.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('CREATE TABLE $TableName(word TEXT PRIMARY KEY, meaning TEXT)');
      //   await db.execute(
      // 'CREATE TABLE $TableName (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  //Create
  createData(MyData myData) async {
    final db = await database;
    var res = await db.rawInsert(
        'INSERT INTO $TableName(word,meaning) VALUES(?,?)', [myData.myWord, myData.meaning]);
    return res;
  }

  //Update
  updateData(MyData myData) async {
    final db = await database;
    var res = db.rawUpdate(
        'UPDATE $TableName SET meaning = ? WHERE word = ?', [myData.meaning, myData.myWord]);
    return res;
  }

  //Read
  getWord(String word) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName WHERE word = ?', [word]);
    return res.isNotEmpty
        ? MyData(myWord: res.first['word'].toString(), meaning: res.first['meaning'].toString())
        : Null;
  }

  //Read All
  Future<List<MyData>> getAllWords() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName');
    List<MyData> list = res.isNotEmpty
        ? res
            .map((c) => MyData(myWord: c['word'].toString(), meaning: c['meaning'].toString()))
            .toList()
        : [];

    return list;
  }

  //Delete
  deleteWord(String word) async {
    final db = await database;
    var res = db.rawDelete('DELETE FROM $TableName WHERE word = ?', [word]);
    return res;
  }

  //Delete All
  deleteAllWords() async {
    final db = await database;
    db.rawDelete('DELETE FROM $TableName');
  }
}
