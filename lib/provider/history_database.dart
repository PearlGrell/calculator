import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HistoryDatabase {
  static final HistoryDatabase instance = HistoryDatabase._init();

  static Database? _database;

  HistoryDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('history.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = join(await getDatabasesPath(), filePath);
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        input TEXT,
        output TEXT
      )
    ''');
  }

  Future<void> insertHistory(Map<String, String> historyItem) async {
    final db = await instance.database;
    await db.insert('history', historyItem);
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await instance.database;
    return await db.query('history', orderBy: 'date');
  }

  Future<void> deleteHistory() async {
    final db = await instance.database;
    await db.delete('history');
  }
}
