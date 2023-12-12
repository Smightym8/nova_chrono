import 'package:flutter/material.dart';
import 'package:nova_chrono/components/create_task_form.dart';

class CreateTaskPage extends StatelessWidget {
  const CreateTaskPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: const Padding(
        padding: EdgeInsets.only(top: 20),
        child: CreateTaskForm(),
      )
    );
  }
}