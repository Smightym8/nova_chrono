import 'package:nova_chrono/application/api/task/task_delete_service.dart';

import '../../../domain/repository/task_repository.dart';
import '../../../injection_container.dart';

class TaskDeleteServiceImpl implements TaskDeleteService {
  late TaskRepository _taskRepository;

  TaskDeleteServiceImpl({TaskRepository? taskRepository}) {
    _taskRepository = taskRepository ?? getIt<TaskRepository>();
  }

  @override
  Future<void> deleteTask(String taskId) async {
    // TODO: Check if task exists
    await _taskRepository.deleteTask(taskId);
  }
}
