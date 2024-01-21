import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/application/api/common_task_name/common_task_name_delete_service.dart';
import 'package:nova_chrono/application/impl/common_task_name/common_task_name_delete_service_impl.dart';
import 'package:nova_chrono/domain/repository/common_task_name_repository.dart';
import 'package:nova_chrono/injection_container.dart';

import '../../mocks/annotations.mocks.dart';
import '../unit_test_injection_container.dart';

void main() {
  group("CommonTaskNameDelete Service Unit Tests", () {
    late MockCommonTaskNameRepository mockCommonTaskNameRepository;
    late CommonTaskNameDeleteService commonTaskNameDeleteService;

    setUpAll(() {
      initializeMockDependencies();

      mockCommonTaskNameRepository = getIt<CommonTaskNameRepository>() as MockCommonTaskNameRepository;
      commonTaskNameDeleteService = CommonTaskNameDeleteServiceImpl();
    });

    test("Given common task name id when deleteCommonTaskName then deleteCommonTaskName is "
        "called with expected id", () async {
      // Given
      var commonTaskNameIdExpected = "1";

      // When
      await commonTaskNameDeleteService.deleteCommonTaskName(commonTaskNameIdExpected);

      // Then
      verify(mockCommonTaskNameRepository.deleteCommonTaskName(commonTaskNameIdExpected));
    });
  });
}
