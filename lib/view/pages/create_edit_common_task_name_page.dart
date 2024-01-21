import 'package:flutter/material.dart';
import 'package:nova_chrono/view/pages/home_page.dart';

import '../../application/api/common_task_name/common_task_name_create_service.dart';
import '../../application/api/common_task_name/common_task_name_edit_service.dart';
import '../../domain/model/task.dart';
import '../../injection_container.dart';
import '../components/create_edit_common_task_name_form.dart';

class CreateEditCommonTaskNamePage extends StatefulWidget {
  const CreateEditCommonTaskNamePage({
    super.key,
    this.commonTaskNameId,
    this.commonTaskName
  });

  final String? commonTaskNameId;
  final String? commonTaskName;

  @override
  State<CreateEditCommonTaskNamePage> createState() => _CreateEditCommonTaskNamePageState();
}

class _CreateEditCommonTaskNamePageState extends State<CreateEditCommonTaskNamePage> {
  late String title;
  late Future<Task?> commonTaskName;

  late CommonTaskNameCreateService _commonTaskNameCreateService;
  late CommonTaskNameEditService _commonTaskNameEditService;

  @override
  void initState() {
    super.initState();

    title = "Create Common Task Name";
    _commonTaskNameCreateService = getIt<CommonTaskNameCreateService>();
    _commonTaskNameEditService = getIt<CommonTaskNameEditService>();

    if (widget.commonTaskNameId != null) {
      title = "Edit Common Task Name";
    }
  }

  Future<void> save(String commonTaskName) async {
    if (widget.commonTaskNameId == null) {
      await _commonTaskNameCreateService.createCommonTaskName(
          commonTaskName);
    } else {
      await _commonTaskNameEditService.editCommonTaskName(
          widget.commonTaskNameId!, commonTaskName);
    }

    navigateToHomePage();
  }

  void navigateToHomePage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const HomePage(title: "NovaChrono")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            child: CreateEditCommonTaskNameForm(
              onPressedFunction: save,
              commonTaskName: widget.commonTaskName,
            ),
          ),
        ));
  }
}
