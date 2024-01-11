import 'package:flutter/material.dart';

class CommonTaskNamesListPage extends StatelessWidget {
  const CommonTaskNamesListPage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        automaticallyImplyLeading: false,
      ),
    );
  }
}