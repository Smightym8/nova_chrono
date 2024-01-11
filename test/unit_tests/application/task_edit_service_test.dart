import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/application/api/task_edit_service.dart';
import 'package:nova_chrono/application/impl/task_edit_service_impl.dart';
import 'package:nova_chrono/domain/model/task.dart';

import '../../mocks/annotations.mocks.dart';

void main() {
  group("TaskEditService Unit Tests", () {
    late TaskEditService taskEditService;
    late MockTaskRepository mockTaskRepository;

    setUpAll(() {
      mockTaskRepository = MockTaskRepository();
      taskEditService = TaskEditServiceImpl(taskRepository: mockTaskRepository);
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

      // When
      taskEditService.editTask(taskId, taskName, startTimestamp, endTimestamp, null);

      // Then
      verify(mockTaskRepository.updateTask(taskExpected));
    });
  });
}