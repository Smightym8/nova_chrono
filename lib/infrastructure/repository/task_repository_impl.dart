import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../injection_container.dart';
import '../database_provider/database_provider.dart';

class TaskRepositoryImpl implements TaskRepository {
  static const String table = 'task';
  static const uuid = Uuid();
  late DatabaseProvider _databaseProvider;

  TaskRepositoryImpl() {
    _databaseProvider = getIt<DatabaseProvider>();
  }

  @override
  String nextIdentity() {
    return uuid.v1();
  }

  @override
  Future<void> add(Task task) async {
    var database = _databaseProvider.database;

    await database.insert(
      table,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }

  @override
  Future<Task?> getById(String taskId) async {
    var database = _databaseProvider.database;

    final List<Map<String, dynamic>> maps = await database.query(
      table,
      where: 'id = ?',
      whereArgs: [taskId],
    );

    List<Task> tasks = List.generate(maps.length, (i) {
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

    Task? task = tasks.firstOrNull;

    return task;
  }

  @override
  Future<List<Task>> getByDate(DateTime date) async {
    var database = _databaseProvider.database;

    final List<Map<String, dynamic>> maps = await database.query(
      table,
      where: 'DATE(startTimestamp) = DATE(?) OR DATE(endTimestamp) = DATE(?)',
      whereArgs: [date.toString(), date.toString()],
    );

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

  @override
  Future<void> updateTask(Task task) async {
    var database = _databaseProvider.database;

    await database.update(
      table,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    var database = _databaseProvider.database;

    await database.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}