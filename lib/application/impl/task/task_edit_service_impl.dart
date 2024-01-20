import 'package:nova_chrono/application/api/task/task_edit_service.dart';

import '../../../domain/model/task.dart';
import '../../../domain/repository/native_encryption_lib_bridge.dart';
import '../../../domain/repository/task_repository.dart';
import '../../../injection_container.dart';

class TaskEditServiceImpl implements TaskEditService {
  late TaskRepository _taskRepository;
  late NativeEncryptionLibBridge _nativeEncryptionLibBridge;

  TaskEditServiceImpl({TaskRepository? taskRepository, NativeEncryptionLibBridge? nativeEncryptionLibBridge}) {
    _taskRepository = taskRepository ?? getIt<TaskRepository>();
    _nativeEncryptionLibBridge = nativeEncryptionLibBridge ?? getIt<NativeEncryptionLibBridge>();
  }

  @override
  Future<void> editTask(String taskId, String taskName, DateTime startTimestamp,
      DateTime endTimestamp, String? details) async {
    // TODO: Check if task to be updated exists
    // TODO: Fetch task from db by id and update it instead of creating new task
    details = details ?? "";

    var encryptedTaskName = _nativeEncryptionLibBridge.encrypt(taskName);
    var encryptedDetails = _nativeEncryptionLibBridge.encrypt(details);

    var task = Task(taskId, encryptedTaskName, startTimestamp, endTimestamp, encryptedDetails);

    await _taskRepository.updateTask(task);
  }
}
