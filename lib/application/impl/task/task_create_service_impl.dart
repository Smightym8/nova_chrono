import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';

import '../../../domain/repository/native_encryption_lib_bridge.dart';
import '../../../injection_container.dart';
import '../../api/task/task_create_service.dart';

class TaskCreateServiceImpl implements TaskCreateService {
  late TaskRepository _taskRepository;
  late NativeEncryptionLibBridge _nativeEncryptionLibBridge;

  TaskCreateServiceImpl({TaskRepository? taskRepository, NativeEncryptionLibBridge? nativeEncryptionLibBridge}) {
    _taskRepository = taskRepository ?? getIt<TaskRepository>();
    _nativeEncryptionLibBridge = nativeEncryptionLibBridge ?? getIt<NativeEncryptionLibBridge>();
  }

  @override
  Future<String> createTask(String taskName, DateTime startTimestamp, DateTime endTimestamp,
      String? details) async {
    String id = _taskRepository.nextIdentity();
    details = details ?? "";

    var encryptedTaskName = _nativeEncryptionLibBridge.encrypt(taskName);
    var encryptedDetails = _nativeEncryptionLibBridge.encrypt(details);

    var task = Task(id, encryptedTaskName, startTimestamp, endTimestamp, encryptedDetails);

    int dbId = await _taskRepository.add(task);
    if (dbId == 0) {
      // TODO: Handle error
      print("Error during saving task!");
    }

    return id;
  }
}