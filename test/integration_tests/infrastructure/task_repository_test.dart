import 'package:flutter_test/flutter_test.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:nova_chrono/infrastructure/database_provider/database_provider.dart';
import 'package:nova_chrono/injection_container.dart';

void main() {
  group("TaskRepository integration tests", () {
    late TaskRepository taskRepository;

    setUpAll(() async {
      await initializeDependencies(isIntegrationTest: true);
    });

    setUp(() async {
      await getIt<DatabaseProvider>().initDatabase();

      taskRepository = getIt<TaskRepository>();
    });

    tearDown(() async {
      await getIt<DatabaseProvider>().closeDatabase();
      await getIt<DatabaseProvider>().deleteDatabase();
    });

    test("Given task when add then expected task is saved in database", () async {
      // Given
      String taskId = taskRepository.nextIdentity();
      Task taskExpected = Task(
          taskId, "Test", DateTime.now(), DateTime.now(), "Some details"
      );

      // When
      await taskRepository.add(taskExpected);

      // Then
      Task? taskActual = await taskRepository.getById(taskId);
      expect(taskActual, taskExpected);
    });

    test("Given date when getByDate then expected tasks are returned", () async {
      // Given
      var startTimestamp3 = DateTime(2023, 12, 12, 13, 30);
      var endTimestamp3 = startTimestamp3.add(const Duration(hours: 1));
      var startTimestamp4 =  DateTime(2023, 12, 12, 14, 30);
      var endTimestamp4 = startTimestamp4.add(const Duration(hours: 2));
      var tasksExpected = <Task>[
        Task("3", "Task 3", startTimestamp3,
            endTimestamp3, "Some Details for task 3"),
        Task("4", "Task 4", startTimestamp4,
            endTimestamp4, "Some Details for task 4"),
      ];

      // When
      var tasksActual = await taskRepository.getByDate(startTimestamp3);

      // Then
      expect(tasksActual.length, tasksExpected.length);
      for (var i = 0; i < tasksExpected.length; i++) {
        var taskExpected = tasksExpected[i];
        var taskActual = tasksActual[i];

        expect(taskActual, taskExpected);
      }
    });

    test("Given task when update then task is updated", () async {
      // Given
      var taskOriginal = Task(
          "1",
          "Task 1",
          DateTime(2023, 1, 20, 14, 30),
          DateTime(2023, 1, 20, 15, 00),
          ""
      );

      var taskUpdated = Task(
          "1",
          "Task 1",
          DateTime(2023, 1, 20, 13, 30),
          DateTime(2023, 1, 20, 14, 00),
          "Some details for task 1"
      );

      // When
      await taskRepository.updateTask(taskUpdated);

      // Then
      var updatedTask = await taskRepository.getById(taskOriginal.id);
      expect(updatedTask, isNot(null));
      expect(updatedTask!.id, taskUpdated.id);
      expect(updatedTask.name, taskUpdated.name);
      expect(updatedTask.startTimestamp, taskUpdated.startTimestamp);
      expect(updatedTask.endTimestamp, taskUpdated.endTimestamp);
      expect(updatedTask.details, taskUpdated.details);

      expect(updatedTask.startTimestamp, isNot(taskOriginal.startTimestamp));
      expect(updatedTask.endTimestamp, isNot(taskOriginal.endTimestamp));
      expect(updatedTask.details, isNot(taskOriginal.details));
    });

    test("Given taskId when delete then task is deleted", () async {
      // Given
      var taskId = "4";

      // When
      await taskRepository.deleteTask(taskId);

      // Then
      var deletedTask = await taskRepository.getById(taskId);
      expect(deletedTask, null);
    });
  });
}