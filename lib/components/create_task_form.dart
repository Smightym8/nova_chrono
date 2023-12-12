import 'package:flutter/material.dart';

class CreateTaskForm extends StatefulWidget {
  const CreateTaskForm({super.key});

  @override
  State<CreateTaskForm> createState() => _CreateTaskFormState();
}

class _CreateTaskFormState extends State<CreateTaskForm> {

  final _formKey = GlobalKey<FormState>();
  final taskNameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    taskNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: taskNameController,
              decoration: const InputDecoration(
                labelText: 'Task name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                Expanded(
                  child:  ElevatedButton (
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Save task
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(taskNameController.text),
                            );
                          },
                        );
                      }
                    },
                    child: const Text('Save'),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                    child: ElevatedButton (
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}