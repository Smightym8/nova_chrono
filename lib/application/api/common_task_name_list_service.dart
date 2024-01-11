import 'package:nova_chrono/domain/model/common_task_name.dart';

abstract class CommonTaskNameListService {
  Future<List<CommonTaskName>> getAllCommonTaskNames();
}