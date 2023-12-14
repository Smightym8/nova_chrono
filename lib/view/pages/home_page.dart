import 'package:flutter/material.dart';

import 'create_task_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
              // TODO: Pass title to page
              const CreateTaskPage(title: "NovaChrono")
            ),
          );
        },
        tooltip: 'Add new task',
        child: const Icon(Icons.add),
      ),
    );
  }
}