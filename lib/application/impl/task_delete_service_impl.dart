import 'package:nova_chrono/application/api/task_delete_service.dart';

import '../../domain/repository/task_repository.dart';
import '../../main.dart';

class TaskDeleteServiceImpl implements TaskDeleteService {
  late TaskRepository _taskRepository;

  TaskDeleteServiceImpl({TaskRepository? taskRepository}) {
    _taskRepository = taskRepository ?? getIt<TaskRepository>();
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _taskRepository.deleteTask(taskId);
  }
}
