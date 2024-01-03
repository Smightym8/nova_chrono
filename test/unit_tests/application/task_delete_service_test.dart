import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/application/api/task_delete_service.dart';
import 'package:nova_chrono/application/impl/task_delete_service_impl.dart';

import '../../mocks/annotations.mocks.dart';

void main() {
  group("TaskDeleteService Tests", () {
    late TaskDeleteService taskDeleteService;
    late MockTaskRepository mockTaskRepository;

    setUpAll(() {
      mockTaskRepository = MockTaskRepository();
      taskDeleteService = TaskDeleteServiceImpl(taskRepository: mockTaskRepository);
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