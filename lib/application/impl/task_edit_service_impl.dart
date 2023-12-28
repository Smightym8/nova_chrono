import 'package:nova_chrono/application/api/task_edit_service.dart';

import '../../domain/model/task.dart';
import '../../domain/repository/task_repository.dart';
import '../../main.dart';

class TaskEditServiceImpl implements TaskEditService {
  late TaskRepository _taskRepository;

  TaskEditServiceImpl({TaskRepository? taskRepository}) {
    _taskRepository = taskRepository ?? getIt<TaskRepository>();
  }

  @override
  void editTask(String taskId, String taskName, DateTime startTimestamp,
      DateTime endTimestamp, String? details) {
    details = details ?? "";

    var task = Task(taskId, taskName, startTimestamp, endTimestamp, details);

    _taskRepository.updateTask(task);
  }
}
