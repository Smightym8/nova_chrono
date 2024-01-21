import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';

import '../../../domain/repository/encryption_repository.dart';
import '../../../injection_container.dart';
import '../../api/task/task_create_service.dart';

class TaskCreateServiceImpl implements TaskCreateService {
  late TaskRepository _taskRepository;
  late EncryptionRepository _nativeEncryptionLibBridge;

  TaskCreateServiceImpl() {
    _taskRepository = getIt<TaskRepository>();
    _nativeEncryptionLibBridge = getIt<EncryptionRepository>();
  }

  @override
  Future<String> createTask(String taskName, DateTime startTimestamp, DateTime endTimestamp,
      String? details) async {
    String id = _taskRepository.nextIdentity();
    details = details ?? "";

    var encryptedTaskName = _nativeEncryptionLibBridge.encrypt(taskName);
    var encryptedDetails = _nativeEncryptionLibBridge.encrypt(details);

    var task = Task(id, encryptedTaskName, startTimestamp, endTimestamp, encryptedDetails);

    await _taskRepository.add(task);

    return id;
  }
}