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

    await generateTestdata(db);
  }

  Future<void> generateTestdata(Database db) async {
    var now = DateTime.now();

    var startTimestamp = now;
    var endTimestamp = now.add(const Duration(hours: 1));
    await db.execute('''
    INSERT INTO task(id, name, startTimestamp, endTimestamp, details)
    VALUES('1', 'Task 1', '${startTimestamp.toString()}', 
    '${endTimestamp.toString()}', '');
    ''');

    var startTimestamp2 = now.subtract(const Duration(hours: 3));
    var endTimestamp2 = startTimestamp2.add(const Duration(hours: 2));
    await db.execute('''
    INSERT INTO task(id, name, startTimestamp, endTimestamp, details)
    VALUES('2', 'Task 2', '${startTimestamp2.toString()}', 
    '${endTimestamp2.toString()}', 'Some details for task 2');
    ''');

    var startTimestamp3 = now.subtract(const Duration(days: 1));
    var endTimestamp3 = startTimestamp3.add(const Duration(hours: 1));
    await db.execute('''
    INSERT INTO task(id, name, startTimestamp, endTimestamp, details)
    VALUES('3', 'Task 3', '${startTimestamp3.toString()}', 
    '${endTimestamp3.toString()}', 'Some details for task 3');
    ''');

    var startTimestamp4 = now.subtract(const Duration(days: 1)).add(const Duration(hours: 1));
    var endTimestamp4 = startTimestamp4.add(const Duration(hours: 2));
    await db.execute('''
    INSERT INTO task(id, name, startTimestamp, endTimestamp, details)
    VALUES('4', 'Task 4', '${startTimestamp4.toString()}', 
    '${endTimestamp4.toString()}', 'Some details for task 4');
    ''');
  }
}
