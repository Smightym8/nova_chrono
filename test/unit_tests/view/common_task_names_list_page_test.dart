import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/domain/model/common_task_name.dart';
import 'package:nova_chrono/view/pages/common_task_names_list_page.dart';

import '../../mocks/annotations.mocks.dart';

void main() {
  group("CommonTaskNamesListPage Unit Tests", () {
    const title = 'NovaChrono';
    late MockCommonTaskNameListService commonTaskNameListServiceMock;
    late MockCommonTaskNameDeleteService commonTaskNameDeleteServiceMock;

    setUpAll(() {
      commonTaskNameListServiceMock = MockCommonTaskNameListService();
      commonTaskNameDeleteServiceMock = MockCommonTaskNameDeleteService();
    });

    testWidgets("When the delete icon is clicked deleteCommonTaskName is "
        "called with the expected id", (tester) async {
      final List<CommonTaskName> commonTaskNames = [
        CommonTaskName("1", "Taskname 1")
      ];
      final Future<List<CommonTaskName>> commonTaskNamesFuture = Future(() => commonTaskNames);

      when(commonTaskNameListServiceMock.getAllCommonTaskNames())
          .thenAnswer((_) => commonTaskNamesFuture);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MaterialApp(
            home: CommonTaskNamesListPage(
              title: title,
              commonTaskNameListService: commonTaskNameListServiceMock,
              commonTaskNameDeleteService: commonTaskNameDeleteServiceMock,
            ),
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