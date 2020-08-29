import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutterroomdatabase/constants/strings.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;
  static Database _database;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if(_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if(_database == null) {
      _database = await initDatabase();
    }
    return _database;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "room.db";
    var roomDatabase = await openDatabase(path, version: 1, onCreate: _createDB);
    return roomDatabase;
  }

  // CREATE DATABASE
  Future _createDB(Database db, int version) async {

    // TABLE OF ROOM ITEMS
        await db.execute('''
              CREATE TABLE $itemTable (
              $cId TEXT PRIMARY KEY,
              $cFieldName TEXT NOT NULL,
              $cComments TEXT,
              $cCubicFeet TEXT NOT NULL, 
              $cWeight TEXT NOT NULL,
              $groupNameId TEXT NOT NULL,
              $density TEXT NOT NULL
              )
        ''');

        // TABLE OF ROOM
        await db.execute('''
              CREATE TABLE $roomTable (
              $roomId TEXT PRIMARY KEY,
              $roomName TEXT NOT NULL,
              $surveyId TEXT NOT NULL,
              FOREIGN KEY ($cId) REFERENCES $itemTable($cId)
              )
        ''');

  }

  // INSERT ROW
  Future<int> insert(Map<String, dynamic> row, String tableName) async {
    Database db = await this.database;
    return await db.insert(tableName, row);
  }

}
