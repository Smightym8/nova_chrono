import 'dart:io';

import 'package:get_it/get_it.dart';

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
import 'domain/repository/native_encryption_lib_bridge.dart';
import 'domain/repository/task_repository.dart';
import 'infrastructure/common_task_name_repository_impl.dart';
import 'infrastructure/database_provider.dart';
import 'infrastructure/encryption_service.dart';
import 'infrastructure/native_encryption_lib_bridge_impl.dart';
import 'infrastructure/task_repository_impl.dart';

// TODO: Fix dependencies so that not all dependencies have to be passed to every widget
GetIt getIt = GetIt.instance;
DatabaseProvider databaseProvider = DatabaseProvider.instance;

Future<void> initializeDependencies({required bool isTesting}) async {
  await databaseProvider.initDatabase();

  if (Platform.isWindows) {
    getIt.registerSingleton<NativeEncryptionLibBridge>(EncryptionService());
  } else {
    getIt.registerSingleton<NativeEncryptionLibBridge>(NativeEncryptionLibBridgeImpl());
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