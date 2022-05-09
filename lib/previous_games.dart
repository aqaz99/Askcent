import 'package:flutter/material.dart';

class PreviousGamesScreen extends StatelessWidget {
  const PreviousGamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text(
          "Previous Games",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const Center(
        child: Text(
          'Previous Game screen',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
