import 'package:flutter/material.dart';

import 'home_page.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    super.key,
    required this.errorMessage,
    this.showBackToHomeButton = true
  });

  final String errorMessage;
  final bool showBackToHomeButton;

  void navigateToHomePage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const HomePage(title: "NovaChrono")
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Error"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            if (showBackToHomeButton)
              ElevatedButton(
                key: const Key('backToHomePageButton'),
                onPressed: () {
                  navigateToHomePage(context);
                },
                child: const Text('Back to HomePage'),
              ),
          ],
        ),
      ),
    );
  }
}