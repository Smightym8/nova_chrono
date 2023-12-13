import 'package:flutter/material.dart';

class CreateTaskForm extends StatefulWidget {
  const CreateTaskForm({super.key});

  @override
  State<CreateTaskForm> createState() => _CreateTaskFormState();
}

class _CreateTaskFormState extends State<CreateTaskForm> {

  final _formKey = GlobalKey<FormState>();
  final taskNameController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final detailsController = TextEditingController();

  Future<void> _selectDate(bool isStart) async {
    DateTime now = DateTime.now();

    await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: DateTime(now.year, now.month, now.day + 1)
    ).then((selectedDate) => {
      if (selectedDate != null) {
          showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          ).then((selectedTime) {
            if (selectedTime != null) {
              DateTime selectedDateTime = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              );

              if (isStart) {
                setState(() {
                  startDateController.text = selectedDateTime.toString();
                });
              } else {
                setState(() {
                  endDateController.text = selectedDateTime.toString();
                });
              }
            }
          })
      }
    });
  }

  void save() {
    // TODO: Save task
    String formValues = 'Task name: ${taskNameController.text}\nStart: ${startDateController.text}'
        '\nEnd: ${endDateController.text}\nDetails: ${detailsController.text}';

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(formValues),
          );
        }
    );
  }

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
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: taskNameController,
              decoration: const InputDecoration(
                labelText: 'Task name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text.';
                }

                return null;
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: startDateController,
                decoration: const InputDecoration(
                  labelText: 'Start',
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_today),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)
                  ),
                ),
                readOnly: true,
                onTap: () {
                  _selectDate(true);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a start date.';
                  }

                  return null;
                },
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: endDateController,
              decoration: const InputDecoration(
                labelText: 'End',
                filled: true,
                prefixIcon: Icon(Icons.calendar_today),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)
                ),
              ),
              readOnly: true,
              onTap: () {
                _selectDate(false);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a end date.';
                }

                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: detailsController,
              decoration: const InputDecoration(
                labelText: 'Details',
                border: OutlineInputBorder(),
              ),
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
                        save();
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