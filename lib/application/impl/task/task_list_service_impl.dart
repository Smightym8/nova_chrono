import 'package:nova_chrono/application/api/task/task_list_service.dart';
import 'package:nova_chrono/domain/model/task.dart';

import '../../../domain/repository/task_repository.dart';
import '../../../main.dart';

class TaskListServiceImpl implements TaskListService {
  late TaskRepository _taskRepository;

  TaskListServiceImpl({TaskRepository? taskRepository}) {
    _taskRepository = taskRepository ?? getIt<TaskRepository>();
  }

  @override
  Future<List<Task>> getTasksByDate(DateTime date) async {
    var tasks = await _taskRepository.getByDate(date);

    tasks.sort((a, b) => b.startTimestamp.compareTo(a.startTimestamp));

    return tasks;
  }
}
