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

    _database = await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
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
  }
}
