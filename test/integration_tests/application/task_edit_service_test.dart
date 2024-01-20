import 'package:flutter_test/flutter_test.dart';
import 'package:nova_chrono/application/api/task/task_edit_service.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/domain/repository/encryption_repository.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:nova_chrono/infrastructure/database_provider/database_provider.dart';
import 'package:nova_chrono/injection_container.dart';

void main() {
  group("TaskEditService Integration Tests", () {
    late TaskRepository taskRepository;
    late TaskEditService taskEditService;

    setUpAll(() async {
      await initializeDependencies(isTesting: true, isIntegrationTesting: true);
    });

    setUp(() async {
      await getIt<DatabaseProvider>().initDatabase();

      taskRepository = getIt<TaskRepository>();
      taskEditService = getIt<TaskEditService>();
    });

    tearDown(() async {
      await getIt<DatabaseProvider>().closeDatabase();
      await getIt<DatabaseProvider>().deleteDatabase();
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

      var updatedStartTimestamp = DateTime(2023, 1, 20, 13, 30);
      var updatedEndTimestamp = DateTime(2023, 1, 20, 14, 00);
      var updatedDetails = "Some details for task 1";

      // When
      await taskEditService.editTask(
          taskOriginal.id,
          taskOriginal.name,
          updatedStartTimestamp,
          updatedEndTimestamp,
          updatedDetails
      );

      // Then
      var updatedTask = await taskRepository.getById(taskOriginal.id);
      expect(updatedTask, isNot(null));

      var decryptedTaskName = getIt<EncryptionRepository>().decrypt(updatedTask!.name);
      var decryptedDetails = getIt<EncryptionRepository>().decrypt(updatedTask.details);

      expect(updatedTask.id, taskOriginal.id);
      expect(decryptedTaskName, taskOriginal.name);
      expect(updatedTask.startTimestamp, updatedStartTimestamp);
      expect(updatedTask.endTimestamp, updatedEndTimestamp);
      expect(decryptedDetails, updatedDetails);

      expect(updatedTask.startTimestamp, isNot(taskOriginal.startTimestamp));
      expect(updatedTask.endTimestamp, isNot(taskOriginal.endTimestamp));
      expect(updatedTask.details, isNot(taskOriginal.details));
    });
  });
}