import 'package:nova_chrono/application/api/common_task_name_list_service.dart';
import 'package:nova_chrono/domain/model/common_task_name.dart';

import '../../domain/repository/common_task_name_repository.dart';
import '../../main.dart';

class CommonTaskNameListServiceImpl implements CommonTaskNameListService {
  late CommonTaskNameRepository _commonTaskNameRepository;

  CommonTaskNameListServiceImpl({CommonTaskNameRepository? commonTaskNameRepository}) {
    _commonTaskNameRepository = commonTaskNameRepository ?? getIt<CommonTaskNameRepository>();
  }

  @override
  Future<List<CommonTaskName>> getAllCommonTaskNames() async {
    return await _commonTaskNameRepository.getAll();
  }

}