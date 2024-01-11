import 'package:nova_chrono/domain/model/common_task_name.dart';
import 'package:nova_chrono/domain/repository/common_task_name_repository.dart';
import 'package:nova_chrono/main.dart';

import '../api/common_task_name_edit_service.dart';

class CommonTaskNameEditServiceImpl implements CommonTaskNameEditService {
  late CommonTaskNameRepository _commonTaskNameRepository;

  CommonTaskNameEditServiceImpl({CommonTaskNameRepository? commonTaskNameRepository}) {
    _commonTaskNameRepository = commonTaskNameRepository ?? getIt<CommonTaskNameRepository>();
  }

  @override
  void editCommonTaskName(String id, String name) {
    var commonTaskName = CommonTaskName(id, name);

    _commonTaskNameRepository.updateCommonTaskName(commonTaskName);
  }
}