import 'package:flutter/material.dart';

import '../../application/api/common_task_name/common_task_name_create_service.dart';
import '../../application/api/common_task_name/common_task_name_delete_service.dart';
import '../../application/api/common_task_name/common_task_name_edit_service.dart';
import '../../application/api/common_task_name/common_task_name_list_service.dart';
import '../../domain/model/common_task_name.dart';
import '../../injection_container.dart';
import '../components/search_box.dart';
import 'create_edit_common_task_name_page.dart';

class CommonTaskNamesListPage extends StatefulWidget {
  const CommonTaskNamesListPage({
    super.key,
    required this.title,
    this.commonTaskNameListService,
    this.commonTaskNameDeleteService,
    this.commonTaskNameCreateService,
    this.commonTaskNameEditService,
  });

  final String title;
  final CommonTaskNameListService? commonTaskNameListService;
  final CommonTaskNameDeleteService? commonTaskNameDeleteService;
  final CommonTaskNameCreateService? commonTaskNameCreateService;
  final CommonTaskNameEditService? commonTaskNameEditService;

  @override
  State<CommonTaskNamesListPage> createState() =>
      _CommonTaskNamesListPageState();
}

class _CommonTaskNamesListPageState extends State<CommonTaskNamesListPage> {
  late CommonTaskNameListService _commonTaskNameListService;
  late CommonTaskNameDeleteService _commonTaskNameDeleteService;
  late String _searchTerm;
  late Future<List<CommonTaskName>> _commonTaskNamesFuture;

  @override
  void initState() {
    _commonTaskNameListService =
        widget.commonTaskNameListService ?? getIt<CommonTaskNameListService>();
    _commonTaskNameDeleteService = widget.commonTaskNameDeleteService ??
        getIt<CommonTaskNameDeleteService>();
    _searchTerm = "";
    _commonTaskNamesFuture = _commonTaskNameListService.getAllCommonTaskNames();

    super.initState();
  }

  void setSearchTerm(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm;
    });
  }

  Future<void> onDeletePressed(String id) async {
    await _commonTaskNameDeleteService.deleteCommonTaskName(id);

    setState(() {
      _commonTaskNamesFuture =
          _commonTaskNameListService.getAllCommonTaskNames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SearchBox(
                  onChanged: setSearchTerm,
                ),
              ),
            ],
          ),
          Expanded(
              child: FutureBuilder(
                  future: _commonTaskNamesFuture,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<CommonTaskName>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Text(
                          "Loading common task names...",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      );
                    } else {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            "No common task names found",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            "An error occurred",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        );
                      } else {
                        var filteredCommonTaskNames = snapshot.data!;

                        if (_searchTerm.isNotEmpty) {
                          filteredCommonTaskNames = filteredCommonTaskNames
                              .where((commonTaskName) => commonTaskName.name
                                  .toLowerCase()
                                  .contains(_searchTerm.toLowerCase()))
                              .toList();
                        }

                        if (filteredCommonTaskNames.isEmpty) {
                          return const Center(
                            child: Text(
                              "No common task names found",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          );
                        } else {
                          return ListView.separated(
                            padding: const EdgeInsets.all(8),
                            itemCount: filteredCommonTaskNames.length,
                            itemBuilder: (BuildContext context, int index) {
                              var id = filteredCommonTaskNames[index].id;
                              var name = filteredCommonTaskNames[index].name;

                              return Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.yellow.shade300,
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 12,
                                          spreadRadius: 1),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          title: Text(
                                            name,
                                            style:
                                                const TextStyle(fontSize: 19),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => CreateEditCommonTaskNamePage(
                                                            commonTaskNameCreateService:
                                                            widget.commonTaskNameCreateService,
                                                            commonTaskNameEditService:
                                                            widget.commonTaskNameEditService,
                                                            commonTaskNameId: id,
                                                            commonTaskName: name,
                                                          )));
                                                },
                                                child: const Icon(
                                                  Icons.edit,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  await onDeletePressed(id);
                                                },
                                                child: const Icon(
                                                  Icons.delete_forever,
                                                  color: Colors.red,
                                                ),
                                              )
                                            ],
                                          ))
                                    ],
                                  ));
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                          );
                        }
                      }
                    }
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key("createEditCommonTaskNamePageFloatingActionButton"),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateEditCommonTaskNamePage(
                        commonTaskNameCreateService:
                            widget.commonTaskNameCreateService,
                        commonTaskNameEditService:
                            widget.commonTaskNameEditService,
                      )));
        },
        tooltip: 'Add new common task name',
        heroTag: "newCommonTaskNameButton",
        child: const Icon(Icons.add),
      ),
    );
  }
}
