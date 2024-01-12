import 'package:nova_chrono/domain/model/common_task_name.dart';

abstract class CommonTaskNameRepository {
  String nextIdentity();
  Future<void> add(CommonTaskName commonTaskName);
  Future<void> updateCommonTaskName(CommonTaskName commonTaskName);
  Future<void> deleteCommonTaskName(String id);
  Future<CommonTaskName?> getById(String id);
  Future<List<CommonTaskName>> getAll();
}