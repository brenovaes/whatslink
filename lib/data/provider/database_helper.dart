import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:whatslink/data/models/Data.dart';

class DatabaseHelper {
  static final _databaseName = "whatslink.db";
  static final _databaseVersion = 1;
  static final table = "items";
  static final columnId = 'id';
  static final columnNumber = 'number';
  static final columnMessage = 'message';
  static final columnUri = 'uri';
  static final columnIsSaved = 'isSaved';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE $table (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnNumber TEXT NOT NULL,
    $columnMessage TEXT,
    $columnUri TEXT NOT NULL,
    $columnIsSaved INTEGER NOT NULL DEFAULT 0
  )
  ''');
  }

  Future<int> insert(Data item) async {
    Database db = await instance.database;
    var res = await db.insert(table, item.toMap());
    return res;
  }

  Future<int> update(Data item) async {
    Database db = await instance.database;
    var res = await db.update(table, item.toMap(),
        where: '$columnId = ?', whereArgs: [item.id]);
    return res;
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    var res = await db.query(table, orderBy: "$columnId DESC");
    return res;
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<void> clearTable(String table) async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE FROM $table");
  }
}
