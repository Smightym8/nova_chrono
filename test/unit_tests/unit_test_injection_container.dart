import 'package:nova_chrono/application/api/common_task_name/common_task_name_create_service.dart';
import 'package:nova_chrono/application/api/common_task_name/common_task_name_delete_service.dart';
import 'package:nova_chrono/application/api/common_task_name/common_task_name_edit_service.dart';
import 'package:nova_chrono/application/api/common_task_name/common_task_name_list_service.dart';
import 'package:nova_chrono/application/api/task/task_create_service.dart';
import 'package:nova_chrono/application/api/task/task_delete_service.dart';
import 'package:nova_chrono/application/api/task/task_edit_service.dart';
import 'package:nova_chrono/application/api/task/task_list_service.dart';
import 'package:nova_chrono/domain/repository/common_task_name_repository.dart';
import 'package:nova_chrono/domain/repository/encryption_repository.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:nova_chrono/injection_container.dart';

import '../mocks/annotations.mocks.dart';

void initializeMockDependencies() {
  // Initialize mocks here because inside of lib we don't have access to the mock classes
  getIt.registerSingleton<TaskRepository>(MockTaskRepository());
  getIt.registerSingleton<CommonTaskNameRepository>(MockCommonTaskNameRepository());
  getIt.registerSingleton<EncryptionRepository>(MockEncryptionRepository());
  getIt.registerSingleton<TaskListService>(MockTaskListService());
  getIt.registerSingleton<TaskCreateService>(MockTaskCreateService());
  getIt.registerSingleton<TaskEditService>(MockTaskEditService());
  getIt.registerSingleton<TaskDeleteService>(MockTaskDeleteService());
  getIt.registerSingleton<CommonTaskNameListService>(MockCommonTaskNameListService());
  getIt.registerSingleton<CommonTaskNameCreateService>(MockCommonTaskNameCreateService());
  getIt.registerSingleton<CommonTaskNameEditService>(MockCommonTaskNameEditService());
  getIt.registerSingleton<CommonTaskNameDeleteService>(MockCommonTaskNameDeleteService());
}