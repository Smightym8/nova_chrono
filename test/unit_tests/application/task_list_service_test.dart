import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/application/api/task/task_list_service.dart';
import 'package:nova_chrono/application/impl/task/task_list_service_impl.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/domain/repository/encryption_repository.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:nova_chrono/injection_container.dart';

import '../../mocks/annotations.mocks.dart';
import '../unit_test_injection_container.dart';

void main() {
  group("TaskListService Unit Tests", () {
    late TaskListService taskListService;
    late MockTaskRepository mockTaskRepository;
    late MockEncryptionRepository mockEncryptionRepository;

    setUpAll(() {
      initializeMockDependencies();

      mockTaskRepository = getIt<TaskRepository>() as MockTaskRepository;
      mockEncryptionRepository = getIt<EncryptionRepository>() as MockEncryptionRepository;
      taskListService = TaskListServiceImpl();
    });

    test(
        "Given three tasks in repository and a date when getByDate "
        "then expected tasks returned", () async {
      // Given
      DateTime dateTime = DateTime(2023, 1, 1);
      List<Task> tasksExpected = <Task>[
        Task("1", "Task 1", dateTime, dateTime, ""),
        Task("2", "Task 2", dateTime, dateTime, ""),
        Task("3", "Task 3", dateTime, dateTime, ""),
      ];

      when(mockTaskRepository.getByDate(dateTime))
          .thenAnswer((_) async => tasksExpected);

      for (Task task in tasksExpected) {
        when(mockEncryptionRepository.decrypt(task.name)).thenReturn(task.name);
        when(mockEncryptionRepository.decrypt(task.details)).thenReturn(task.details);
      }

      // When
      List<Task> tasksActual = await taskListService.getTasksByDate(dateTime);

      // Then
      expect(tasksActual.length, tasksExpected.length);
      for (var i = 0; i < tasksExpected.length; i++) {
        Task taskExpected = tasksExpected[i];
        Task taskActual = tasksActual[i];

        expect(taskActual, taskExpected);
      }
    });
  });
}
