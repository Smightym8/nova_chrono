import '../../domain/model/task.dart';

abstract class TaskListService {
  List<Task> getAllTasks();
}
