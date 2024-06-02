import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "homepackage.db";
  static const _databaseVersion = 1;

  static const tableUsers = 'users';
  static const tableHomebook = 'homebook';
  static const tableAdmin = 'administrator';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  //////////////////////////////
  Future<List<Map<String, dynamic>>> getUsers() async {
    Database db = await instance.database;
    return await db.query(tableUsers,
        columns: ['userid', 'name', 'email', 'phone', 'username', 'password']);
  }

  Future<int> insertBooking(
      int userid,
      DateTime bookdatetime,
      DateTime checkindate,
      DateTime checkoutdate,
      String homestypackage,
      int numguest,
      double packageprice) async {
    Database db = await instance.database;

    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    DateFormat timeFormat = DateFormat('HH:mm:ss');

    return await db.insert(tableHomebook, {
      'userid': userid,
      'bookdate': dateFormat.format(bookdatetime),
      'booktime': timeFormat.format(bookdatetime),
      'checkindate': dateFormat.format(checkindate),
      'checkoutdate': dateFormat.format(checkoutdate),
      'homestypackage': homestypackage,
      'numguest': numguest,
      'packageprice': packageprice,
    });
  }

  Future<List<Map<String, dynamic>>> getBookings() async {
    Database db = await instance.database;

    return await db.rawQuery('''
    SELECT $tableHomebook.*, $tableUsers.name as name
    FROM $tableHomebook
    INNER JOIN $tableUsers ON $tableHomebook.userid = $tableUsers.userid
  ''');
  }

  Future<List<Map<String, dynamic>>> getBookingsForUser(int userId) async {
    Database db = await instance.database;
    return await db
        .query(tableHomebook, where: 'userid = ?', whereArgs: [userId]);
  }

  Future<int> deleteUser(int id) async {
    Database db = await instance.database;
    return await db.delete(tableUsers, where: 'userid =?', whereArgs: [id]);
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

  Future<void> insertUser(Map<String, dynamic> user) async {
    Database db = await instance.database;

    // Check if the username already exists
    String username = user['username'];
    List<Map> result = await db.query(
      tableUsers,
      columns: ['userid'],
      where: 'username = ?',
      whereArgs: [username],
    );

    // If username exists, throw an exception
    if (result.isNotEmpty) {
      throw Exception('Username already exists');
    }

    // Insert the new user if the username is unique
    await db.insert(tableUsers, user);
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

    // Check if there is another user with the same username
    String username = user['username'];
    List<Map> result = await db.query(
      'users',
      columns: ['userid'],
      where: 'username = ? AND userid != ?',
      whereArgs: [username, userid],
    );

    // If there's a user with the same username, throw an exception
    if (result.isNotEmpty) {
      throw Exception('Username already exists');
    }

    // Proceed with the update if no duplicate is found
    return await db.update(
      'users',
      user,
      where: 'userid = ?',
      whereArgs: [userid],
    );
  }
}
