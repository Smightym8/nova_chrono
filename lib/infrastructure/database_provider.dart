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
  }
}
