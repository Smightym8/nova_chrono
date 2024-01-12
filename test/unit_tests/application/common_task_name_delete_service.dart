import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/application/api/common_task_name_delete_service.dart';
import 'package:nova_chrono/application/impl/common_task_name_delete_service_impl.dart';

import '../../mocks/annotations.mocks.dart';

void main() {
  group("CommonTaskNameDelete Service Unit Tests", () {
    late MockCommonTaskNameRepository commonTaskNameRepositoryMock;
    late CommonTaskNameDeleteService commonTaskNameDeleteService;

    setUpAll(() {
      commonTaskNameRepositoryMock = MockCommonTaskNameRepository();
      commonTaskNameDeleteService = CommonTaskNameDeleteServiceImpl(
          commonTaskNameRepository: commonTaskNameRepositoryMock);
    });

    test("Given common task name id when deleteCommonTaskName then deleteCommonTaskName is "
        "called with expected id", () async {
      // Given
      var commonTaskNameIdExpected = "1";

      // When
      await commonTaskNameDeleteService.deleteCommonTaskName(commonTaskNameIdExpected);

      // Then
      verify(commonTaskNameRepositoryMock.deleteCommonTaskName(commonTaskNameIdExpected));
    });
  });
}
