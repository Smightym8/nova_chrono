import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';

import '../../main.dart';
import '../api/task_create_service.dart';

class TaskCreateServiceImpl implements TaskCreateService {
  late TaskRepository _taskRepository;

  TaskCreateServiceImpl({TaskRepository? taskRepository}) {
    _taskRepository = taskRepository ?? getIt<TaskRepository>();
  }

  @override
  Future<String> createTask(String taskName, DateTime startTimestamp, DateTime endTimestamp,
      String? details) async {
    String id = _taskRepository.nextIdentity();
    details = details ?? "";

    var task = Task(id, taskName, startTimestamp, endTimestamp, details);

    int dbId = await _taskRepository.add(task);
    if (dbId == 0) {
      // TODO: Handle error
      print("Error during saving task!");
    }

    return id;
  }
}