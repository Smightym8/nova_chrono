import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key, required this.onChanged});

  final Function onChanged;

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  late TextEditingController _textFieldController;

  @override
  void initState() {
    _textFieldController = TextEditingController();

    super.initState();
  }


  @override
  void dispose() {
    _textFieldController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black),
        ),
        child: TextField(
          key: const Key("searchBoxTextField"),
          controller: _textFieldController,
          onChanged: (_) => widget.onChanged(_textFieldController.text),
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.black,
                size: 20,
              ),
              prefixIconConstraints: const BoxConstraints(
                maxHeight: 20,
                maxWidth: 20,
              ),
              suffixIcon: _textFieldController.text.isNotEmpty ?
              GestureDetector(
                onTap: () {
                  _textFieldController.clear();
                  widget.onChanged(_textFieldController.text);
                },
                child: const Icon(
                  Icons.clear,
                  color: Colors.black,
                  size: 20,
                ),
              ) : null,
              suffixIconConstraints: const BoxConstraints(
                maxHeight: 20,
                maxWidth: 20,
              ),
              border: InputBorder.none,
              hintText: "Search by name",
              hintStyle: const TextStyle(color: Colors.grey)
          ),
        ),
      ),
    );
  }
}
