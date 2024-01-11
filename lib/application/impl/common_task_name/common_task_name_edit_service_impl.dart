import 'package:nova_chrono/domain/repository/common_task_name_repository.dart';
import 'package:nova_chrono/main.dart';

import '../../api/common_task_name/common_task_name_edit_service.dart';


class CommonTaskNameEditServiceImpl implements CommonTaskNameEditService {
  late CommonTaskNameRepository _commonTaskNameRepository;

  CommonTaskNameEditServiceImpl({CommonTaskNameRepository? commonTaskNameRepository}) {
    _commonTaskNameRepository = commonTaskNameRepository ?? getIt<CommonTaskNameRepository>();
  }

  @override
  Future<void> editCommonTaskName(String id, String name) async {
    var commonTaskName = await _commonTaskNameRepository.getById(id);

    if (commonTaskName == null) {
      // TODO: Throw exception
      print("CommonTaskName not found!");
    }

    commonTaskName?.update(name);

    _commonTaskNameRepository.updateCommonTaskName(commonTaskName!);
  }
}