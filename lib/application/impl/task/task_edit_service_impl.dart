import 'package:nova_chrono/application/api/task/task_edit_service.dart';

import '../../../domain/model/task.dart';
import '../../../domain/repository/task_repository.dart';
import '../../../main.dart';

class TaskEditServiceImpl implements TaskEditService {
  late TaskRepository _taskRepository;

  TaskEditServiceImpl({TaskRepository? taskRepository}) {
    _taskRepository = taskRepository ?? getIt<TaskRepository>();
  }

  @override
  Future<void> editTask(String taskId, String taskName, DateTime startTimestamp,
      DateTime endTimestamp, String? details) async {
    // TODO: Check if task to be updated exists
    // TODO: Fetch task from db by id and update it instead of creating new task
    details = details ?? "";

    var task = Task(taskId, taskName, startTimestamp, endTimestamp, details);

    await _taskRepository.updateTask(task);
  }
}
