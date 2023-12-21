import 'package:nova_chrono/application/api/task_list_service.dart';
import 'package:nova_chrono/domain/model/task.dart';

class TaskListServiceImpl implements TaskListService {
  @override
  List<Task> getAllTasks() {
    return <Task>[
      Task('1', 'Task 1', DateTime.now(), DateTime.now(), ''),
      Task('2', 'Task 2', DateTime.now(), DateTime.now(), ''),
      Task('3', 'Task 3', DateTime.now(), DateTime.now(), '')
    ];
  }
}
