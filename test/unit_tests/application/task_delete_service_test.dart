import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/application/api/task/task_delete_service.dart';
import 'package:nova_chrono/application/impl/task/task_delete_service_impl.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:nova_chrono/injection_container.dart';

import '../../mocks/annotations.mocks.dart';
import '../unit_test_injection_container.dart';

void main() {
  group("TaskDeleteService Unit Tests", () {
    late TaskDeleteService taskDeleteService;
    late MockTaskRepository mockTaskRepository;

    setUpAll(() {
      initializeMockDependencies();

      mockTaskRepository = getIt<TaskRepository>() as MockTaskRepository;
      taskDeleteService = TaskDeleteServiceImpl();
    });

    test("Given taskId when calling deleteTask then "
        "mockTaskRepository.delete is called", () {
      // Given
      String taskId = "1";

      // When
      taskDeleteService.deleteTask(taskId);

      // Then
      verify(mockTaskRepository.deleteTask(taskId));
    });
  });
}