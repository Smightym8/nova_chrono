import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:nova_chrono/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class TaskRepositoryImpl implements TaskRepository {
  static const String table = 'task';
  static const uuid = Uuid();
  late Database _database;

  TaskRepositoryImpl({Database? database}) {
    _database = database ?? databaseProvider.database;
  }

  @override
  String nextIdentity() {
    return uuid.v1();
  }

  @override
  Future<void> add(Task task) async {
    await _database.insert(
      table,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<Task?> getById(String taskId) async {
    final List<Map<String, dynamic>> maps = await _database.query(
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
    final List<Map<String, dynamic>> maps = await _database.query(
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
    await _database.update(
      table,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    await _database.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}