import 'dart:math';

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
    final today = DateTime.now();

    var taskId = 1;
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 3; j++) {
        final startTimestamp = today.subtract(Duration(days: i));
        final endTimestamp = startTimestamp.add(Duration(minutes: Random().nextInt(120) + 20)); // Random duration between 20 and 140 minutes

        final sqlStatement = '''
          INSERT INTO task(id, name, startTimestamp, endTimestamp, details)
          VALUES('$taskId', 'Task $taskId', '${startTimestamp.toString()}', 
          '${endTimestamp.toString()}', 'Some details for task $taskId');
        ''';

        await db.execute(sqlStatement);

        taskId++;
      }
    }
  }
}
