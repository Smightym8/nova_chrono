import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateTaskForm extends StatefulWidget {
  const CreateTaskForm({super.key, required this.onPressedFunction});

  final Function onPressedFunction;

  @override
  State<CreateTaskForm> createState() => _CreateTaskFormState();
}

class _CreateTaskFormState extends State<CreateTaskForm> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _taskNameController;
  late TextEditingController _startTimestampController;
  late TextEditingController _endTimestampController;
  late TextEditingController _detailsController;
  late DateTime _selectedStartTimeStamp;
  late DateTime _selectedEndTimeStamp;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();

    _selectedStartTimeStamp = DateTime.now();
    _selectedEndTimeStamp = DateTime.now();

    _taskNameController = TextEditingController();
    _startTimestampController = TextEditingController(text: _formatDate(_selectedStartTimeStamp));
    _endTimestampController = TextEditingController();
    _detailsController = TextEditingController();

    super.initState();
  }

  static String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd - HH:mm').format(date);
  }

  Future<void> _selectDate(bool isStart) async {
    DateTime now = DateTime.now();

    await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: DateTime(now.year, now.month, now.day + 1)
    ).then((selectedDate) => {
      if (selectedDate != null) {
          showTimePicker(context: context, initialTime: TimeOfDay.now(),
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
                  _selectedStartTimeStamp = selectedDateTime;
                  _startTimestampController.text = _formatDate(selectedDateTime);
                });
              } else {
                setState(() {
                  _selectedEndTimeStamp = selectedDateTime;
                  _endTimestampController.text = _formatDate(selectedDateTime);
                });
              }
            }
          })
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _taskNameController.dispose();
    _startTimestampController.dispose();
    _endTimestampController.dispose();
    _detailsController.dispose();
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
              controller: _taskNameController,
              decoration: const InputDecoration(
                labelText: 'Task name',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)
                ),
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
                controller: _startTimestampController,
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
              controller: _endTimestampController,
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

                if (_selectedEndTimeStamp.compareTo(_selectedStartTimeStamp) < 0) {
                  return 'End has to be after start.';
                }

                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: _detailsController,
              decoration: const InputDecoration(
                labelText: 'Details',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                Expanded(
                  child:  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onPressedFunction(
                          _taskNameController.text,
                          _selectedStartTimeStamp,
                          _selectedEndTimeStamp,
                          _detailsController.text
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