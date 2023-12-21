import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseProvider {
  static const _databaseName = "novachrono.db";
  static const _databaseVersion = 1;
  late Database _database;

  DatabaseProvider._privateConstructor();

  static final DatabaseProvider instance =
      DatabaseProvider._privateConstructor();

  Database get database => _database;

  initDatabase() async {
    String path = join(".", _databaseName);

    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    _database = await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE task (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            startTimestamp TEXT NOT NULL,
            endTimestamp TEXT NOT NULL,
            details TEXT NOT NULL
          )
    ''');

    await db.execute('''
      INSERT INTO task(id, name, startTimestamp, endTimestamp, details)
      VALUES('1', 'Task 1', '2023-12-21 12:00:04.847854', '2023-12-21 12:20:04.847854', 'Some details')
      ''');
    await db.execute('''
      INSERT INTO task(id, name, startTimestamp, endTimestamp, details)
      VALUES('2', 'Task 2', '2023-12-21 13:00:04.847854', '2023-12-19 14:0:04.847854', 'Some details')
      ''');
    await db.execute('''
      INSERT INTO task(id, name, startTimestamp, endTimestamp, details)
      VALUES('3', 'Task 3', '2023-12-21 15:00:04.847854', '2023-12-19 17:0:04.847854', 'Some details')
      ''');
  }
}
