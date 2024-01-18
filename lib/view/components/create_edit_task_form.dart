import 'package:flutter/material.dart';
import 'package:nova_chrono/view/shared/date_formatter.dart';

import '../../domain/model/common_task_name.dart';

// TODO: integrate common task names as suggestions

class CreateEditTaskForm extends StatefulWidget {
  const CreateEditTaskForm({
    super.key,
    required this.onSavePressed,
    this.taskName,
    this.startTimestamp,
    this.endTimestamp,
    this.details,
    required this.commonTaskNames
  });

  final Function onSavePressed;
  final String? taskName;
  final DateTime? startTimestamp;
  final DateTime? endTimestamp;
  final String? details;
  final List<CommonTaskName> commonTaskNames;

  @override
  State<CreateEditTaskForm> createState() => _CreateEditTaskFormState();
}

class _CreateEditTaskFormState extends State<CreateEditTaskForm> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _taskNameController;
  late TextEditingController _taskNameSelectionController;
  late TextEditingController _startTimestampController;
  late TextEditingController _endTimestampController;
  late TextEditingController _detailsController;
  late DateTime _selectedStartTimeStamp;
  late DateTime _selectedEndTimeStamp;
  late String? _taskNameSelectionErrorText;
  late List<DropdownMenuEntry<String>> _commonTaskNames;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _taskNameSelectionErrorText = null;
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
    _taskNameSelectionController = TextEditingController();
    _startTimestampController = TextEditingController(
        text: DateFormatter.formatDateWithTime(_selectedStartTimeStamp)
    );
    _endTimestampController = TextEditingController(
            text: DateFormatter.formatDateWithTime(_selectedEndTimeStamp)
      );
    _detailsController = TextEditingController(text: widget.details);

    _commonTaskNames = [];
    for (var taskName in widget.commonTaskNames) {
      var dropdownMenuEntry = DropdownMenuEntry<String>(value: taskName.name, label: taskName.name);

      _commonTaskNames.add(dropdownMenuEntry);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _taskNameController.dispose();
    _taskNameSelectionController.dispose();
    _startTimestampController.dispose();
    _endTimestampController.dispose();
    _detailsController.dispose();

    super.dispose();
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

  Future<void> submitForm() async {
    bool isValid = _formKey.currentState!.validate();

    if (_taskNameController.text.isEmpty && _taskNameSelectionController.text.isEmpty) {
      setState(() {
        _taskNameSelectionErrorText = 'Or select a task name.';
      });
    }

    if (isValid) {
      var taskName = _taskNameController.text.isEmpty ?
      _taskNameSelectionController.text : _taskNameController.text;

      await widget.onSavePressed(
          taskName,
          _selectedStartTimeStamp,
          _selectedEndTimeStamp,
          _detailsController.text
      );
    }
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
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
                    onChanged: (_) {
                      setState(() {
                        _taskNameSelectionController.text = '';
                      });
                    },
                    validator: (value) {
                      if (_taskNameSelectionController.text.isEmpty && (value == null || value.isEmpty)) {
                        return 'Please enter a task name.';
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: DropdownMenu<String>(
                    controller: _taskNameSelectionController,
                    label: const Text('Common Task name'),
                    errorText: _taskNameSelectionErrorText,
                    expandedInsets: const EdgeInsets.all(0) ,
                    enableFilter: true,
                    inputDecorationTheme: const InputDecorationTheme(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)
                      ),
                    ),
                    onSelected: (String? value) {
                      setState(() {
                        _taskNameController.text = '';
                        _taskNameSelectionErrorText = null;
                      });
                    },
                    dropdownMenuEntries: _commonTaskNames,
                  ),
                ),
              ],
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
                      onPressed: submitForm,
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