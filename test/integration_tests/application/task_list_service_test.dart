import 'package:flutter_test/flutter_test.dart';
import 'package:nova_chrono/application/api/task/task_list_service.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/infrastructure/database_provider/database_provider.dart';
import 'package:nova_chrono/injection_container.dart';

void main() {
  group("TaskListService Integration Tests", () {
    late TaskListService taskListService;

    setUpAll(() async {
      await initializeDependencies(isTesting: true, isIntegrationTesting: true);
    });

    setUp(() async {
      await getIt<DatabaseProvider>().initDatabase();

      taskListService = getIt<TaskListService>();
    });

    tearDown(() async {
      await getIt<DatabaseProvider>().closeDatabase();
      await getIt<DatabaseProvider>().deleteDatabase();
    });

    test("Given date when getByDate then expected tasks are returned", () async {
      // Given
      var now = DateTime.now();
      var startTimestamp3 = now.subtract(const Duration(days: 1));
      var endTimestamp3 = startTimestamp3.add(const Duration(hours: 1));
      var startTimestamp4 = now.subtract(const Duration(days: 1)).add(const Duration(hours: 1));
      var endTimestamp4 = startTimestamp4.add(const Duration(hours: 2));
      var tasksExpected = <Task>[
        Task("4", "Task 4", startTimestamp4,
            endTimestamp4, "Some Details for task 4"),
        Task("3", "Task 3", startTimestamp3,
            endTimestamp3, "Some Details for task 3"),
      ];

      // When
      var tasksActual = await taskListService.getTasksByDate(startTimestamp3);

      // Then
      expect(tasksActual.length, tasksExpected.length);
      for (var i = 0; i < tasksExpected.length; i++) {
        var taskExpected = tasksExpected[i];
        var taskActual = tasksActual[i];

        expect(taskActual, taskExpected);
      }
    });
  });
}