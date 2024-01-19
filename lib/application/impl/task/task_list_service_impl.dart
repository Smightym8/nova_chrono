import 'package:nova_chrono/application/api/task/task_list_service.dart';
import 'package:nova_chrono/domain/model/task.dart';

import '../../../domain/repository/native_encryption_lib_bridge.dart';
import '../../../domain/repository/task_repository.dart';
import '../../../main.dart';

class TaskListServiceImpl implements TaskListService {
  late TaskRepository _taskRepository;
  late NativeEncryptionLibBridge _nativeEncryptionLibBridge;

  TaskListServiceImpl({TaskRepository? taskRepository, NativeEncryptionLibBridge? nativeEncryptionLibBridge}) {
    _taskRepository = taskRepository ?? getIt<TaskRepository>();
    _nativeEncryptionLibBridge = nativeEncryptionLibBridge ?? getIt<NativeEncryptionLibBridge>();
  }

  @override
  Future<List<Task>> getTasksByDate(DateTime date) async {
    var encryptedTasks = await _taskRepository.getByDate(date);
    var decryptedTasks = <Task>[];

    for (var task in encryptedTasks) {
      var decryptedTaskName = _nativeEncryptionLibBridge.decrypt(task.name);
      var decryptedTaskDetails = _nativeEncryptionLibBridge.decrypt(task.details);
      var decryptedTask = Task(task.id, decryptedTaskName, task.startTimestamp, task.endTimestamp, decryptedTaskDetails);

      decryptedTasks.add(decryptedTask);
    }

    decryptedTasks.sort((a, b) => b.startTimestamp.compareTo(a.startTimestamp));

    return decryptedTasks;
  }
}
