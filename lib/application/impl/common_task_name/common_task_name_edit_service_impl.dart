import 'package:nova_chrono/domain/repository/common_task_name_repository.dart';

import '../../../injection_container.dart';
import '../../api/common_task_name/common_task_name_edit_service.dart';


class CommonTaskNameEditServiceImpl implements CommonTaskNameEditService {
  late CommonTaskNameRepository _commonTaskNameRepository;

  CommonTaskNameEditServiceImpl() {
    _commonTaskNameRepository = getIt<CommonTaskNameRepository>();
  }

  @override
  Future<void> editCommonTaskName(String id, String name) async {
    var commonTaskName = await _commonTaskNameRepository.getById(id);

    if (commonTaskName == null) {
      // TODO: Throw exception
      print("CommonTaskName not found!");
    }

    commonTaskName?.update(name);

    await _commonTaskNameRepository.updateCommonTaskName(commonTaskName!);
  }
}