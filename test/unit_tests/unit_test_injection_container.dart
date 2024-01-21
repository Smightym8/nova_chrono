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
}