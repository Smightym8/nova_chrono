import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';

import '../../main.dart';
import '../api/task_create_service.dart';

class TaskCreateServiceImpl implements TaskCreateService {
  final TaskRepository taskRepository = getIt<TaskRepository>();

  @override
  void createTask(String taskName, DateTime startTimestamp, DateTime endTimestamp,
      String? details) {

    details = details ?? "";

    var task = Task(taskName, startTimestamp, endTimestamp, details);

    taskRepository.add(task);
  }
}