import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';

import '../../main.dart';
import '../api/task_create_service.dart';

class TaskCreateServiceImpl implements TaskCreateService {
  final TaskRepository taskRepository = getIt<TaskRepository>();

  @override
  void createTask(String taskName, String startTimestamp, String endTimestamp,
      String? details) {

    var startTimestampAsDate = DateTime.parse(startTimestamp);
    var endTimestampAsDate = DateTime.parse(endTimestamp);
    details = details ?? "";

    var task = Task(taskName, startTimestampAsDate, endTimestampAsDate,
        details);

    taskRepository.add(task);
  }
}