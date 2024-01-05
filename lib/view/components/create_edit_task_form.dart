import 'package:flutter/material.dart';
import 'package:nova_chrono/view/shared/date_formatter.dart';

class CreateEditTaskForm extends StatefulWidget {
  const CreateEditTaskForm(
      {super.key,
      required this.onPressedFunction,
      this.taskName,
      this.startTimestamp,
      this.endTimestamp,
      this.details});

  final Function onPressedFunction;
  final String? taskName;
  final DateTime? startTimestamp;
  final DateTime? endTimestamp;
  final String? details;

  @override
  State<CreateEditTaskForm> createState() => _CreateEditTaskFormState();
}

class _CreateEditTaskFormState extends State<CreateEditTaskForm> {
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
    initForm();

    super.initState();
  }

  void initForm() {
    if (widget.taskName != null) {
      _selectedStartTimeStamp = widget.startTimestamp!;
      _selectedEndTimeStamp = widget.endTimestamp!;
    } else {
      _selectedStartTimeStamp = DateTime.now();
      _selectedEndTimeStamp = DateTime(
        _selectedStartTimeStamp.year,
        _selectedStartTimeStamp.month,
        _selectedStartTimeStamp.day,
        _selectedStartTimeStamp.hour + 1,
        _selectedStartTimeStamp.minute,
      );
    }

    _taskNameController = TextEditingController(text: widget.taskName);
    _startTimestampController = TextEditingController(
        text: DateFormatter.formatDateWithTime(_selectedStartTimeStamp)
    );
    _endTimestampController = TextEditingController(
            text: DateFormatter.formatDateWithTime(_selectedEndTimeStamp)
      );
    _detailsController = TextEditingController(text: widget.details);
  }

  Future<void> _selectDate(bool isStart) async {
    DateTime firstDate = _selectedStartTimeStamp;
    DateTime initialDate;
    DateTime lastDate;

    if (isStart) {
      initialDate = _selectedStartTimeStamp;
      lastDate = _selectedStartTimeStamp;
    } else {
      initialDate = _selectedEndTimeStamp;
      lastDate = DateTime(firstDate.year, firstDate.month, firstDate.day + 1);
    }

    await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate
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
                  _startTimestampController.text = DateFormatter.formatDateWithTime(selectedDateTime);
                });
              } else {
                setState(() {
                  _selectedEndTimeStamp = selectedDateTime;
                  _endTimestampController.text = DateFormatter.formatDateWithTime(selectedDateTime);
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
              key: const Key('taskNameTextField'),
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
              key: const Key('startTimestampTextField'),
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
              key: const Key('endTimestampTextField'),
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
              key: const Key('detailsTextField'),
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
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      key: const Key('saveButton'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onPressedFunction(
                              _taskNameController.text,
                              _selectedStartTimeStamp,
                              _selectedEndTimeStamp,
                              _detailsController.text);
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      key: const Key('cancelButton'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
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