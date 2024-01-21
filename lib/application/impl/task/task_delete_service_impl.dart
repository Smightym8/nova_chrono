import 'package:nova_chrono/application/api/exception/task_not_found_exception.dart';
import 'package:nova_chrono/application/api/task/task_delete_service.dart';

import '../../../domain/repository/task_repository.dart';
import '../../../injection_container.dart';

class TaskDeleteServiceImpl implements TaskDeleteService {
  late TaskRepository _taskRepository;

  TaskDeleteServiceImpl() {
    _taskRepository = getIt<TaskRepository>();
  }

  @override
  Future<void> deleteTask(String taskId) async {
    var task = await _taskRepository.getById(taskId);

    if (task == null) {
      throw TaskNotFoundException('Task with id $taskId not found.');
    }

    await _taskRepository.deleteTask(taskId);
  }
}
