import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {
  static final DbProvider _instance = DbProvider._internal();
  Database? _database;

  factory DbProvider() {
    return _instance;
  }

  DbProvider._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    return await initDB();
  }

  initDB() async {
    String path = join(await getDatabasesPath(), "rwc.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    String roomSql = '''CREATE TABLE room(
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        roomId TEXT,
                        roomName TEXT,
                        userName TEXT)''';
    String messageSql = '''CREATE TABLE message(
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    type TEXT,
                    roomId TEXT,
                    sender TEXT,
                    message TEXT,
                    time TEXT)''';

    await db.execute(roomSql);
    await db.execute(messageSql);
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // temp
    if (newVersion == 2) {
      // Modify scheme
      await db.execute("DROP TABLE room");
      await db.execute("DROP TABLE message");

      String roomSql = '''CREATE TABLE room(
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        roomId TEXT,
                        roomName TEXT,
                        userName TEXT)''';

      String messageSql = '''CREATE TABLE message(
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    type TEXT,
                    roomId TEXT,
                    sender TEXT,
                    message TEXT,
                    time INTEGER)''';

      await db.execute(roomSql);
      await db.execute(messageSql);
    } else if (newVersion == 4) {
      // Delete all rows
      await db.execute("DELETE FROM room");
      await db.execute("DELETE FROM message");
    }
  }
}
