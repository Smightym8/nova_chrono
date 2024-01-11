import 'package:flutter/material.dart';

class CreateEditCommonTaskNameForm extends StatefulWidget {
  const CreateEditCommonTaskNameForm(
      {super.key,
      required this.onPressedFunction,
      this.commonTaskName});

  final Function onPressedFunction;
  final String? commonTaskName;

  @override
  State<CreateEditCommonTaskNameForm> createState() => _CreateEditCommonTaskNameFormState();
}

class _CreateEditCommonTaskNameFormState extends State<CreateEditCommonTaskNameForm> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _commonTaskNameController;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    initForm();

    super.initState();
  }

  void initForm() {
    _commonTaskNameController = TextEditingController(text: widget.commonTaskName);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _commonTaskNameController.dispose();
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
              key: const Key('commonTaskNameTextField'),
              controller: _commonTaskNameController,
              decoration: const InputDecoration(
                labelText: 'Common task name',
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
                              _commonTaskNameController.text);
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