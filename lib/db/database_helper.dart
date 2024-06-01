import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "homepackage.db";
  static final _databaseVersion = 1;

  static final tableUsers = 'users';
  static final tableHomebook = 'homebook';
  static final tableAdmin = 'administrator';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableUsers (
        userid INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone INTEGER NOT NULL,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableHomebook (
        bookid INTEGER PRIMARY KEY,
        userid INTEGER NOT NULL,
        bookdate DATE NOT NULL,
        booktime TIME NOT NULL,
        checkindate DATE NOT NULL,
        checkoutdate DATE NOT NULL,
        homestypackage TEXT NOT NULL,
        numguest INTEGER NOT NULL,
        packageprice DOUBLE NOT NULL,
        FOREIGN KEY (userid) REFERENCES $tableUsers (userid)
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableAdmin (
        adminid INTEGER PRIMARY KEY,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  Future<Map<String, dynamic>?> getUserById(int userid) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results =
        await db.query(tableUsers, where: 'userid = ?', whereArgs: [userid]);

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<int> updateUser(int userid, Map<String, dynamic> user) async {
    Database db = await instance.database;
    return await db.update(
      'users',
      user,
      where: 'userid = ?',
      whereArgs: [userid],
    );
  }
}
