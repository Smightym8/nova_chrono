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
}