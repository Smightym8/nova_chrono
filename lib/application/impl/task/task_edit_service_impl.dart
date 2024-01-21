import 'package:nova_chrono/application/api/task/task_edit_service.dart';

import '../../../domain/repository/encryption_repository.dart';
import '../../../domain/repository/task_repository.dart';
import '../../../injection_container.dart';
import '../../api/exception/task_not_found_exception.dart';

class TaskEditServiceImpl implements TaskEditService {
  late TaskRepository _taskRepository;
  late EncryptionRepository _nativeEncryptionLibBridge;

  TaskEditServiceImpl() {
    _taskRepository = getIt<TaskRepository>();
    _nativeEncryptionLibBridge = getIt<EncryptionRepository>();
  }

  @override
  Future<void> editTask(String taskId, String taskName, DateTime startTimestamp,
      DateTime endTimestamp, String? details) async {
    var task = await _taskRepository.getById(taskId);

    if (task == null) {
      throw TaskNotFoundException('Task with id $taskId not found.');
    }

    details = details ?? "";

    var encryptedTaskName = _nativeEncryptionLibBridge.encrypt(taskName);
    var encryptedDetails = _nativeEncryptionLibBridge.encrypt(details);

    task.update(encryptedTaskName, startTimestamp, endTimestamp, encryptedDetails);

    await _taskRepository.updateTask(task);
  }
}
