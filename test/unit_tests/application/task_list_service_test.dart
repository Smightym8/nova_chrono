import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/application/api/task_list_service.dart';
import 'package:nova_chrono/application/impl/task_list_service_impl.dart';
import 'package:nova_chrono/domain/model/task.dart';

import '../../mocks/annotations.mocks.dart';

void main() {
  group("TaskListService tests", () {
    late TaskListService taskListService;
    late MockTaskRepository mockTaskRepository;

    setUpAll(() {
      mockTaskRepository = MockTaskRepository();
      taskListService = TaskListServiceImpl(taskRepository: mockTaskRepository);
    });

    test(
        "Given three tasks in repository and a date when getByDate "
        "then expected tasks returned", () async {
      // Given
      DateTime dateTime = DateTime.now();
      List<Task> tasksExpected = <Task>[
        Task("1", "Task 1", dateTime, dateTime, ""),
        Task("2", "Task 2", dateTime, dateTime, ""),
        Task("3", "Task 3", dateTime, dateTime, ""),
      ];
      final Future<List<Task>> tasksFuture = Future(() => tasksExpected);

      when(mockTaskRepository.getByDate(dateTime))
          .thenAnswer((_) => tasksFuture);

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
