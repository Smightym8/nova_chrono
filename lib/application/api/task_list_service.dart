import '../../domain/model/task.dart';

abstract class TaskListService {
  Future<List<Task>> getAllTasks();
}
