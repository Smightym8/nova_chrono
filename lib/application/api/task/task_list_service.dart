import '../../../domain/model/task.dart';

abstract class TaskListService {
  Future<List<Task>> getTasksByDate(DateTime date);
}
