import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:nova_chrono/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class TaskRepositoryImpl implements TaskRepository {
  static const String table = 'task';
  static const uuid = Uuid();

  @override
  String nextIdentity() {
    return uuid.v1();
  }

  @override
  Future<void> add(Task task) async {
    var database = databaseProvider.database;

    await database.insert(
      table,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<Task>> getAll() async {
    var database = databaseProvider.database;
    final List<Map<String, dynamic>> maps = await database.query(table);

    return List.generate(maps.length, (i) {
      var id = maps[i]['id'] as String;
      var name = maps[i]['name'] as String;
      var startTimestamp = maps[i]['startTimestamp'] as String;
      var endTimestamp = maps[i]['endTimestamp'] as String;
      var details = maps[i]['details'] as String;

      return Task(
        id,
        name,
        DateTime.parse(startTimestamp),
        DateTime.parse(endTimestamp),
        details,
      );
    });
  }
}