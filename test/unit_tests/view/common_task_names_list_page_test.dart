import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/application/api/common_task_name/common_task_name_delete_service.dart';
import 'package:nova_chrono/application/api/common_task_name/common_task_name_list_service.dart';
import 'package:nova_chrono/domain/model/common_task_name.dart';
import 'package:nova_chrono/injection_container.dart';
import 'package:nova_chrono/view/pages/common_task_names_list_page.dart';

import '../../mocks/annotations.mocks.dart';
import '../unit_test_injection_container.dart';

void main() {
  group("CommonTaskNamesListPage Unit Tests", () {
    const title = 'NovaChrono';
    late MockCommonTaskNameListService commonTaskNameListServiceMock;
    late MockCommonTaskNameDeleteService commonTaskNameDeleteServiceMock;

    setUpAll(() {
      initializeMockDependencies();

      commonTaskNameListServiceMock = getIt<CommonTaskNameListService>() as MockCommonTaskNameListService;
      commonTaskNameDeleteServiceMock = getIt<CommonTaskNameDeleteService>() as MockCommonTaskNameDeleteService;
    });

    testWidgets("When the delete icon is clicked deleteCommonTaskName is "
        "called with the expected id", (tester) async {
      final List<CommonTaskName> commonTaskNames = [
        CommonTaskName("1", "Taskname 1")
      ];

      when(commonTaskNameListServiceMock.getAllCommonTaskNames())
          .thenAnswer((_) async => commonTaskNames);

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: MaterialApp(
            home: CommonTaskNamesListPage(title: title),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final deleteInkWellFinder = find.widgetWithIcon(
          InkWell,
          Icons.delete_forever
      ).first;

      await tester.tap(deleteInkWellFinder);

      await tester.pumpAndSettle();

      verify(commonTaskNameDeleteServiceMock.deleteCommonTaskName(commonTaskNames[0].id));
    });
  });
}