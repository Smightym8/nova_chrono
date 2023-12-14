import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';

// TODO: Use other form of storing tasks
class TaskRepositoryImpl implements TaskRepository {
  final List<Task> _taskList = [];

  @override
  void add(Task task) {
    _taskList.add(task);
  }
}