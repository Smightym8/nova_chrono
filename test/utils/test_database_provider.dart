import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TestDatabaseProvider {
  static const _databaseName = "novachrono_test.db";
  static const _databaseVersion = 1;
  late Database _database;

  TestDatabaseProvider._privateConstructor();

  static final TestDatabaseProvider instance = TestDatabaseProvider
      ._privateConstructor();

  Database get database => _database;

  Future<void> initDatabase() async {
    String path = join(".", _databaseName);

    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      readOnly: false
    );
  }

  Future<void> closeDatabase() async {
    await _database.close();
  }

  Future<void> deleteDatabase() async {
    String path = join(".", _databaseName);

    await databaseFactory.deleteDatabase(path);
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

    await generateTestdata(db);
  }

  Future<void> generateTestdata(Database db) async {
    var startTimestamp = DateTime.now();
    var endTimestamp = startTimestamp.add(const Duration(hours: 1));

    await db.execute('''
    INSERT INTO task(id, name, startTimestamp, endTimestamp, details)
    VALUES('1', 'Task 1', '${startTimestamp.toString()}', 
    '${endTimestamp.toString()}', '');
    ''');

    startTimestamp = startTimestamp.add(const Duration(hours: -3));
    endTimestamp = startTimestamp.add(const Duration(hours: -2));
    await db.execute('''
    INSERT INTO task(id, name, startTimestamp, endTimestamp, details)
    VALUES('2', 'Task 2', '${startTimestamp.toString()}', 
    '${endTimestamp.toString()}', 'Some details for task 2');
    ''');

    startTimestamp = startTimestamp.add(const Duration(days: -2));
    endTimestamp = startTimestamp.add(const Duration(hours: 3));
    await db.execute('''
    INSERT INTO task(id, name, startTimestamp, endTimestamp, details)
    VALUES('3', 'Task 3', '${startTimestamp.toString()}', 
    '${endTimestamp.toString()}', 'Some details for task 3');
    ''');

    startTimestamp = startTimestamp.add(const Duration(hours: 1));
    endTimestamp = startTimestamp.add(const Duration(hours: 2));
    await db.execute('''
    INSERT INTO task(id, name, startTimestamp, endTimestamp, details)
    VALUES('4', 'Task 4', '${startTimestamp.toString()}', 
    '${endTimestamp.toString()}', 'Some details for task 4');
    ''');
  }
}
