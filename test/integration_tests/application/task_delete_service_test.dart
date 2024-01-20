import 'package:flutter_test/flutter_test.dart';
import 'package:nova_chrono/application/api/task/task_delete_service.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:nova_chrono/infrastructure/database_provider/database_provider.dart';
import 'package:nova_chrono/injection_container.dart';

void main() {
  group("TaskDeleteService Integration Tests", () {
    late TaskRepository taskRepository;
    late TaskDeleteService taskDeleteService;

    setUpAll(() async {
      await initializeDependencies(isTesting: true, isIntegrationTesting: true);
    });

    setUp(() async {
      await getIt<DatabaseProvider>().initDatabase();

      taskRepository = getIt<TaskRepository>();
      taskDeleteService = getIt<TaskDeleteService>();
    });

    tearDown(() async {
      await getIt<DatabaseProvider>().closeDatabase();
      await getIt<DatabaseProvider>().deleteDatabase();
    });

    test("Given taskId when calling deleteTask then task is deleted", () async {
      // Given
      String taskId = "1";

      // When
      await taskDeleteService.deleteTask(taskId);

      // Then
      Task? deletedTask = await taskRepository.getById(taskId);
      expect(deletedTask, null);
    });
  });
}