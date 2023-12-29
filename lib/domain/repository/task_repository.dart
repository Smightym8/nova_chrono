import 'package:nova_chrono/domain/model/task.dart';

abstract class TaskRepository {
  String nextIdentity();
  void add(Task task);

  Future<List<Task>> getByDate(DateTime date);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
}