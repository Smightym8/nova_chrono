import 'package:nova_chrono/domain/model/task.dart';

abstract class TaskRepository {
  String nextIdentity();
  Future<int> add(Task task);
  Future<Task?> getById(String taskId);
  Future<List<Task>> getByDate(DateTime date);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
}