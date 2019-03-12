import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pending_task_app/model/pending_task.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.getInstance();
  static Database _db;

  final String tableName = "pendingTask";
  final String columnId = "id";
  final String columnName = "name";
  final String columnCreated = "created";

  DatabaseHelper.getInstance();

  factory DatabaseHelper() => _instance;

  Future<Database> get db async {
    if (_db == null) _db = await initializeDatabase();

    return _db;
  }

  initializeDatabase() async {
    Directory databaseDirectory = await getApplicationDocumentsDirectory();
    String path = join(databaseDirectory.path, "tasks.db");

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, $columnName TEXT, $columnCreated TEXT);");
    print("table created");
  }

  // CRUD Operations

  Future<int> saveItem(PendingTask task) async {
    var dbClient = await db;
    int result = await dbClient.insert(tableName, task.toMap());

    print("The item was created!!!");
    return result;
  }

  Future<List> getTasks() async {
    var dbClient = await db;
    var tasksResult = await dbClient
        .rawQuery("SELECT * FROM $tableName ORDER BY $columnName ASC");

    return tasksResult.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  Future<PendingTask> getItem(int id) async {
    var dbClient = await db;
    var result =
        await dbClient.rawQuery("SELECT * FROM $tableName WHERE id = $id");

    if (result.length == 0) return null;
    return PendingTask.fromMap(result.first);
  }

  Future<int> updateItem(PendingTask task) async {
    var dbClient = await db;
    return await dbClient.update(tableName, task.toMap(),
        where: "$columnId = ?", whereArgs: [task.id]);
  }

  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
