import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/application/api/task/task_edit_service.dart';
import 'package:nova_chrono/application/impl/task/task_edit_service_impl.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/domain/repository/encryption_repository.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:nova_chrono/injection_container.dart';

import '../../mocks/annotations.mocks.dart';
import '../unit_test_injection_container.dart';

void main() {
  group("TaskEditService Unit Tests", () {
    late TaskEditService taskEditService;
    late MockTaskRepository mockTaskRepository;
    late MockEncryptionRepository mockEncryptionRepository;

    setUpAll(() {
      initializeMockDependencies();

      mockTaskRepository = getIt<TaskRepository>() as MockTaskRepository;
      mockEncryptionRepository = getIt<EncryptionRepository>() as MockEncryptionRepository;
      taskEditService = TaskEditServiceImpl();
    });

    test("Given task with details when update then taskRepository.updateTask "
        "is called with expected task", () {
      // Given
      const taskId = '1';
      const taskName = 'Test Task';
      final startTimestamp = DateTime.now();
      final endTimestamp = startTimestamp.add(const Duration(hours: 1));
      const details = 'Some details';
      final taskExpected = Task(taskId, taskName, startTimestamp, endTimestamp, details);

      when(mockEncryptionRepository.encrypt(taskName)).thenReturn(taskName);
      when(mockEncryptionRepository.encrypt(details)).thenReturn(details);

      // When
      taskEditService.editTask(taskId, taskName, startTimestamp, endTimestamp, details);

      // Then
      verify(mockTaskRepository.updateTask(taskExpected));
    });

    test("Given task without details when update then taskRepository.updateTask "
        "is called with expected task", () {
      // Given
      const taskId = '1';
      const taskName = 'Test Task';
      final startTimestamp = DateTime.now();
      final endTimestamp = startTimestamp.add(const Duration(hours: 1));
      final taskExpected = Task(taskId, taskName, startTimestamp, endTimestamp, '');

      when(mockEncryptionRepository.encrypt(taskName)).thenReturn(taskName);
      when(mockEncryptionRepository.encrypt('')).thenReturn('');

      // When
      taskEditService.editTask(taskId, taskName, startTimestamp, endTimestamp, null);

      // Then
      verify(mockTaskRepository.updateTask(taskExpected));
    });
  });
}