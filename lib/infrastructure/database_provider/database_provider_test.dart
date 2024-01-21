import 'package:nova_chrono/infrastructure/database_provider/database_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseProviderTest implements DatabaseProvider {
  static const _databaseName = "novachrono_test.db";
  static const _databaseVersion = 1;
  late Database _database;

  @override
  Database get database => _database;

  @override
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

  @override
  Future<void> closeDatabase() async {
    await _database.close();
  }

  @override
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

    await db.execute('''
          CREATE TABLE common_task_name (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL
          )
    ''');

    await generateTestdata(db);
  }

  Future<void> generateTestdata(Database db) async {
    var now = DateTime.now();

    var startTimestamp = now;
    var endTimestamp = now.add(const Duration(hours: 1));
    var taskName = "#1)bs";
    var taskDetails = '';

    await db.execute('''
    INSERT INTO task(id, name, startTimestamp, endTimestamp, details)
    VALUES('1', ?, '${startTimestamp.toString()}', 
    '${endTimestamp.toString()}', ?);
    ''', [taskName, taskDetails]);

    var startTimestamp2 = now.subtract(const Duration(hours: 3));
    var endTimestamp2 = startTimestamp2.add(const Duration(hours: 2));
    taskName = '#1)bp';
    taskDetails = '-/\'b&\'6#+.1b\$-0b6#1)bp';

    await db.execute('''
    INSERT INTO task(id, name, startTimestamp, endTimestamp, details)
    VALUES('2', ?, '${startTimestamp2.toString()}',
    '${endTimestamp2.toString()}', ?);
    ''', [taskName, taskDetails]);

    var startTimestamp3 = DateTime(2023, 12, 12, 13, 30);
    var endTimestamp3 = startTimestamp3.add(const Duration(hours: 1));
    taskName = '#1)bq';
    taskDetails = '-/\'b&\'6#+.1b\$-0b6#1)bq';

    await db.execute('''
    INSERT INTO task(id, name, startTimestamp, endTimestamp, details)
    VALUES('3', ?, '${startTimestamp3.toString()}', 
    '${endTimestamp3.toString()}', ?);
    ''', [taskName, taskDetails]);

    var startTimestamp4 = DateTime(2023, 12, 12, 14, 30);
    var endTimestamp4 = startTimestamp4.add(const Duration(hours: 2));
    taskName = '#1)bv';
    taskDetails = '-/\'b&\'6#+.1b\$-0b6#1)bv';

    await db.execute('''
    INSERT INTO task(id, name, startTimestamp, endTimestamp, details)
    VALUES('4', ?, '${startTimestamp4.toString()}', 
    '${endTimestamp4.toString()}', ?);
    ''', [taskName, taskDetails]);

    var commonTaskNameId = 1;
    for (int i = 0; i < 5; i++) {
      final sqlStatement = '''
          INSERT INTO common_task_name(id, name)
          VALUES('$commonTaskNameId', 'Common task name $commonTaskNameId');
        ''';

      await db.execute(sqlStatement);

      commonTaskNameId++;
    }
  }
}