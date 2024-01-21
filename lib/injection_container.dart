import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:nova_chrono/infrastructure/database_provider/database_provider.dart';

import 'application/api/common_task_name/common_task_name_create_service.dart';
import 'application/api/common_task_name/common_task_name_delete_service.dart';
import 'application/api/common_task_name/common_task_name_edit_service.dart';
import 'application/api/common_task_name/common_task_name_list_service.dart';
import 'application/api/task/task_create_service.dart';
import 'application/api/task/task_delete_service.dart';
import 'application/api/task/task_edit_service.dart';
import 'application/api/task/task_list_service.dart';
import 'application/impl/common_task_name/common_task_name_create_service_impl.dart';
import 'application/impl/common_task_name/common_task_name_delete_service_impl.dart';
import 'application/impl/common_task_name/common_task_name_edit_service_impl.dart';
import 'application/impl/common_task_name/common_task_name_list_service_impl.dart';
import 'application/impl/task/task_create_service_impl.dart';
import 'application/impl/task/task_delete_service_impl.dart';
import 'application/impl/task/task_edit_service_impl.dart';
import 'application/impl/task/task_list_service_impl.dart';
import 'domain/repository/common_task_name_repository.dart';
import 'domain/repository/encryption_repository.dart';
import 'domain/repository/task_repository.dart';
import 'infrastructure/database_provider/database_provider_prod.dart';
import 'infrastructure/database_provider/database_provider_test.dart';
import 'infrastructure/encryption/dart_encryption_repository.dart';
import 'infrastructure/encryption/native_encryption_repository.dart';
import 'infrastructure/repository/common_task_name_repository_impl.dart';
import 'infrastructure/repository/task_repository_impl.dart';

// TODO: Fix dependencies so that not all dependencies have to be passed to every widget
GetIt getIt = GetIt.instance;

Future<void> initializeDependencies({bool isIntegrationTest = false}) async {
  if (isIntegrationTest) {
    getIt.registerSingleton<DatabaseProvider>(DatabaseProviderTest());
  } else {
    getIt.registerSingleton<DatabaseProvider>(DatabaseProviderProduction());
  }

  if (Platform.isWindows || isIntegrationTest) {
    getIt.registerSingleton<EncryptionRepository>(DartEncryptionRepository());
  } else {
    getIt.registerSingleton<EncryptionRepository>(NativeEncryptionRepository());
  }

  getIt.registerSingleton<TaskRepository>(TaskRepositoryImpl());
  getIt.registerSingleton<TaskCreateService>(TaskCreateServiceImpl());
  getIt.registerSingleton<TaskListService>(TaskListServiceImpl());
  getIt.registerSingleton<TaskEditService>(TaskEditServiceImpl());
  getIt.registerSingleton<TaskDeleteService>(TaskDeleteServiceImpl());
  getIt.registerSingleton<CommonTaskNameRepository>(CommonTaskNameRepositoryImpl());
  getIt.registerSingleton<CommonTaskNameCreateService>(CommonTaskNameCreateServiceImpl());
  getIt.registerSingleton<CommonTaskNameEditService>(CommonTaskNameEditServiceImpl());
  getIt.registerSingleton<CommonTaskNameListService>(CommonTaskNameListServiceImpl());
  getIt.registerSingleton<CommonTaskNameDeleteService>(CommonTaskNameDeleteServiceImpl());
}